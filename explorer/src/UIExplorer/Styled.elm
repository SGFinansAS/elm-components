module UIExplorer.Styled exposing (StyledStories, StyledStory, styledStoriesOf)

import Html.Styled exposing (Html, toUnstyled)
import UIExplorer exposing (Model, UI, storiesOf)
import UIExplorer.Unstyled exposing (Stories, Story)


type alias StyledStory a b c =
    ( String, Model a b c -> Html b, c )


type alias StyledStories a b c =
    List (StyledStory a b c)


styledStoriesOf : String -> StyledStories a b c -> UI a b c
styledStoriesOf id stories =
    storiesOf id (toUnstyledStories stories)


toUnstyledStories : StyledStories a b c -> Stories a b c
toUnstyledStories stories =
    List.map toUnstyledStory stories


toUnstyledStory : StyledStory a b c -> Story a b c
toUnstyledStory ( a, b, c ) =
    ( a, \x -> toUnstyled (b x), c )
