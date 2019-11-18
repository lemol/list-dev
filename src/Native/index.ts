import { Elm } from "../Main";
import createAuth0Client from '@auth0/auth0-spa-js';

const app = Elm.Main.init({
  node: document.getElementById("app"),
  flags: null,
});

const getAuth0 = createAuth0Client({
  domain: 'github-ao.eu.auth0.com',
  client_id: 'QtJ3O01q7fhSSmo3Mt3yk75XWmDkQdOi'
});


app.ports.requestLogin.subscribe(async () => {
  const auth0 = await getAuth0;

  await auth0.loginWithPopup();
  await setAuthState();
});

app.ports.requestLogout.subscribe(async () => {
  const auth0 = await getAuth0;
  await auth0.logout({
    returnTo: window.location.origin
  })
});

async function setAuthState() {
  const auth0 = await getAuth0;
  const isAuthenticated = await auth0.isAuthenticated();

  if(!isAuthenticated) {
    return app.ports.setAuthState.send(null);
  }

  const user = await auth0.getUser();

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
}