import { Elm } from "./Explorer.elm";

if (module.hot) {
  // UIExplorer stores story views in its model, which Elm hot updates preserve.
  // Reload to initialize those views from the updated code.
  window.addEventListener("parcelhmraccept", () => window.location.reload());
}

Elm.Explorer.init({
  node: document.getElementById("root"),
});
