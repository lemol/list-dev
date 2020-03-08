import { Elm } from "../Main";
import createAuth0Client from "@auth0/auth0-spa-js";

const app = Elm.Main.init({
  node: document.getElementById("app"),
  flags: {
    width: window.innerWidth,
    height: window.innerHeight
  }
});

const redirectUri = `${window.location.protocol}//${window.location.host}`;

const getAuth0 = createAuth0Client({
  domain: process.env.AUTH0_DOMAIN,
  client_id: process.env.AUTH0_CLIENT_ID,
  redirect_uri: redirectUri
});

app.ports.requestLogin.subscribe(async () => {
  const auth0 = await getAuth0;

  await auth0.loginWithRedirect({
    redirect_uri: redirectUri
  });

  await setAuthState();
});

app.ports.requestLogout.subscribe(async () => {
  const auth0 = await getAuth0;
  await auth0.logout({
    returnTo: window.location.origin
  });
});

async function setAuthState() {
  const auth0 = await getAuth0;
  const isAuthenticated = await auth0.isAuthenticated();

  if (!isAuthenticated) {
    return app.ports.setAuthState.send(null);
  }

  const user = await auth0.getUser();
  const token = await auth0.getIdTokenClaims();

  user.accessToken = token.__raw;

  app.ports.setAuthState.send(user);
}

window.onload = async () => {
  const auth0 = await getAuth0;

  const isAuthenticated = await auth0.isAuthenticated();

  if (isAuthenticated) {
    return setAuthState();
  }

  const query = window.location.search;

  if (query.includes("code=") && query.includes("state=")) {
    await auth0.handleRedirectCallback();
    window.history.replaceState({}, document.title, "/");
  }

  setAuthState();
};
