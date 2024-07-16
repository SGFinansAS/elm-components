module ReviewConfig exposing (config)

{-| Do not rename the ReviewConfig module or the config function, because
`elm-review` will look for these.

To add packages that contain rules, add them to this review project using

    `elm install author/packagename`

when inside the directory containing this file.

For using elm-review and adding new rules see -> <https://github.com/jfmengels/node-elm-review>

-}

import NoBooleanCase
import NoUnused.Dependencies
import NoUnused.Parameters
import NoUnused.Patterns
import NoUnused.Variables
import Review.Rule exposing (Rule)
import Simplify
import NoConfusingPrefixOperator
import NoExposingEverything
import NoImportingEverything


config : List Rule
config =
    [ NoBooleanCase.rule
    , NoUnused.Dependencies.rule
    , NoUnused.Parameters.rule
    , NoUnused.Patterns.rule
    , NoUnused.Variables.rule
    , Simplify.rule Simplify.defaults
    , NoConfusingPrefixOperator.rule
    , NoExposingEverything.rule
    , NoImportingEverything.rule []
    ]
