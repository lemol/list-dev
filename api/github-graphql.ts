import fetch from "node-fetch";
import {
  makeRemoteExecutableSchema,
  makeExecutableSchema
} from "graphql-tools";
import { ApolloServer } from "apollo-server-micro";
import { createHttpLink } from "apollo-link-http";
import { schema as githubSchema } from "@octokit/graphql-schema";

const makeGithubLink = () =>
  createHttpLink({
    uri: `https://api.github.com/graphql`,
    fetch: fetch as any,
    headers: {
      Authorization: "Bearer d4b00a34b2e50d5a59a9f1114b584ff457a9303d"
    }
  });

const githubIntrospectionSchema = makeExecutableSchema({
  typeDefs: githubSchema.idl
});

const githubExecutableSchema = makeRemoteExecutableSchema({
  schema: githubIntrospectionSchema,
  link: makeGithubLink()
});

const server = new ApolloServer({
  schema: githubExecutableSchema,
  introspection: true,
  playground: false
});

export = server.createHandler({ path: "/api/github-graphql.ts" });
