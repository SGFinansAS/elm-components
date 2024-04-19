module Nordea.Components.OnClickOutsideSupport exposing (view)

import Css exposing (display, none)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (attribute, css, srcdoc)
import Nordea.Html as Html


view : { isActive : Bool } -> Html msg
view { isActive } =
    Html.iframe
        [ css [ display none ]
        , attribute "data-is-active"
            (if isActive then
                "true"

             else
                "false"
            )
        , srcdoc
            """
                <script>
                    const id = "click-outside-" + Math.random();
                    const parent = window.parent;
                    const frameEl = window.frameElement;
                    frameEl.setAttribute("id", id);

                    if (!parent.outsideClickListeners) {
                        parent.outsideClickListeners = {};

                        parent.document.addEventListener("click", e => {
                            Object.entries(parent.outsideClickListeners).forEach(([key, listener]) => {
                                if (!parent.document.getElementById(key)) {
                                    delete parent.outsideClickListeners[key];
                                    alert("Deleted listener");
                                } else {
                                    listener(e);
                                }
                            });
                        })
                    }

                    parent.outsideClickListeners[id] = event => {
                        if (frameEl.dataset.isActive && !frameEl.parentElement.contains(event.target)) {
                            parent.dispatchEvent(new CustomEvent("build"))
                        }
                    }
                </script>
            """
        ]
        []
