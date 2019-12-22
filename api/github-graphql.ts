import { NowRequest, NowResponse } from "@now/node";
import fetch from "node-fetch";
import {
  makeRemoteExecutableSchema,
  makeExecutableSchema
} from "graphql-tools";
import { ApolloServer } from "apollo-server-micro";
import { createHttpLink } from "apollo-link-http";
import { schema as githubSchema } from "@octokit/graphql-schema";
import axios from "axios";
import jwksClient from "jwks-rsa";
import * as jwt from "jsonwebtoken";

let micro: any;
let cors: any;

if (!process.env.NOW_REGION) {
  micro = require("micro");
  cors = require("micro-cors")();
}

const AUTH0_DOMAIN = process.env.AUTH0_DOMAIN;

let auth0AdminToken = null;

async function getSigninKey(kid: string) {
  const client = jwksClient({
    strictSsl: true,
    jwksUri: `https://${AUTH0_DOMAIN}/.well-known/jwks.json`
  });

  return new Promise((resolve, reject) => {
    client.getSigningKey(kid, (err, key) => {
      if (err) {
        reject(err);
        return;
      }

      resolve((key as any).publicKey || (key as any).rsaPublicKey);
    });
  });
}

async function verifyAuth0UserToken(token: string) {
  const decodedToken = jwt.decode(token, { complete: true }) as any;
  const kid = decodedToken.header.kid;

  const signinKey = (await getSigninKey(kid)) as any;

  const options = {
    algorithms: ["RS256"]
  };

  return new Promise((resolve, reject) => {
    jwt.verify(token, signinKey, options, (verifyError, decoded) => {
      if (verifyError) {
        reject({ verifyError });
        return;
      }

      resolve(decoded);
    });
  });
}

async function getAuth0AdminToken() {
  if (auth0AdminToken) {
    return auth0AdminToken;
  }

  const result = await axios.post(`https://${AUTH0_DOMAIN}/oauth/token`, {
    client_id: process.env.AUTH0_CLIENT_ID,
    client_secret: process.env.AUTH0_CLIENT_SECRET,
    audience: `https://${AUTH0_DOMAIN}/api/v2/`,
    grant_type: "client_credentials"
  });

  auth0AdminToken = result.data.access_token;

  return auth0AdminToken;
}

async function getGithubToken(userId, adminToken) {
  const result = await axios.get(
    `https://${AUTH0_DOMAIN}/api/v2/users/${userId}`,
    {
      headers: {
        authorization: `Bearer ${adminToken}`
      }
    }
  );

  return result.data.identities
    .filter(x => x.provider === "github")
    .map(x => x.access_token)[0];
}

function makeGithubLink(token: string | null) {
  const authorization = token ? { authorization: `Bearer ${token}` } : {};

  return createHttpLink({
    uri: `https://api.github.com/graphql`,
    fetch: fetch as any,
    headers: {
      ...authorization
    }
  });
}

async function makeGithubToken(accessToken: string) {
  const adminToken = await getAuth0AdminToken();
  const user = await verifyAuth0UserToken(accessToken);
  const githubToken = await getGithubToken((user as any).sub, adminToken);

  return githubToken;
}

export = async (req: NowRequest, res: NowResponse) => {
  const accessToken =
    req.headers.authorization && req.headers.authorization.substring(7);
  const githubToken = accessToken && (await makeGithubToken(accessToken));

  const githubIntrospectionSchema = makeExecutableSchema({
    typeDefs: githubSchema.idl,
    resolverValidationOptions: {
      requireResolversForResolveType: false
    }
  });

  const githubExecutableSchema = makeRemoteExecutableSchema({
    schema: githubIntrospectionSchema,
    link: makeGithubLink(githubToken)
  });

  const server = new ApolloServer({
    schema: githubExecutableSchema,
    introspection: true,
    playground: false
  });

  const handler = server.createHandler({ path: "/api/github-graphql.ts" });

  return makeHandler(handler)(req, res);
};

function makeHandler(handler) {
  if (!micro) {
    return handler;
  }

  return cors((req, res) => {
    if (req.method === "OPTIONS") {
      return micro.send(res, 200, "ok");
    }

    return handler(req, res);
  });
}
