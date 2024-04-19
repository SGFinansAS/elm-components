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
                    const doc = window.parent.document;
                    const id = "click-outside-" + Math.random();
                    const frameEl = window.frameElement;
                    frameEl.setAttribute("id", id);

                    const listener = event => {
                        if (!doc.getElementById(id)) {
                            doc.removeEventListener("click", listener);
                        } else if (frameEl.dataset.isActive === "true" && !frameEl.parentElement.contains(event.target)) {
                            frameEl.parentElement.dispatchEvent(new CustomEvent('outsideclick'));
                        }
                    };

                    doc.addEventListener("click", listener);
                </script>
            """
        ]
        []
