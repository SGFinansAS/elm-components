module Stories.InfoPanel exposing (stories)

import Config exposing (Config, Msg)
import Nordea.Components.InfoPanel as InfoPanel
import UIExplorer exposing (UI)
import UIExplorer.Styled exposing (styledStoriesOf)


stories : UI Config Msg {}
stories =
    styledStoriesOf
        "InfoPanel"
        [ ( "With two info lines"
          , \_ ->
                InfoPanel.view
                    [ { label = "Main information"
                      , info = "Navn Navnesen"
                      }
                    , { label = "Secundary information"
                      , info = "010120133970"
                      }
                    ]
          , {}
          )
        , ( "With one info line"
          , \_ ->
                InfoPanel.view
                    [ { label = "Main information"
                      , info = "Navn Navnesen"
                      }
                    ]
          , {}
          )
        , ( "With several info lines"
          , \_ ->
                InfoPanel.view
                    [ { label = "Main information"
                      , info = "Navn Navnesen"
                      }
                    , { label = "Secundary information 1"
                      , info = "Some information"
                      }
                    , { label = "Secundary information 2"
                      , info = "More information"
                      }
                    , { label = "Secundary information 3"
                      , info = "Even more information"
                      }
                    , { label = "Secundary information 4"
                      , info = "Even more information"
                      }
                    ]
          , {}
          )
        ]
