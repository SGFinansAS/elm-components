module Nordea.Components.OnClickOutsideSupport exposing (view)

import Css exposing (display, none)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (attribute, css, srcdoc)


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
        , srcdoc jsCode
        ]
        []


jsCode =
    """
    <script>
        const doc = window.parent.document;
        const f = window.frameElement;

        const id = "co-" + Math.random();
        f.setAttribute("id", id);

        const listener = e => {
            if (!doc.getElementById(id)) {
                doc.removeEventListener("click", listener);
            } else if (f.dataset.isActive === "true" && !f.parentElement.contains(e.target)) {
                f.parentElement.dispatchEvent(new CustomEvent('outsideclick'));
            }
        };

        doc.addEventListener("click", listener);
    </script>
    """
        |> String.split "\n"
        |> List.map String.trim
        |> List.filter (String.isEmpty >> not)
        |> String.join "\n"
