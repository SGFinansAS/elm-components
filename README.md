# elm-components

## Running locally
From project root run `(cd explorer/; yarn start)`. This will start the application at `localhost:8000`

## Integration

- Take a look at https://github.com/SGFinansAS/sgfinans24beta/pull/649 and https://github.com/SGFinansAS/sgfinans24beta/pull/656


## Themes

Themeing is supported through CSS variables: https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

We currently have three css variables for themeing: `PrimaryColor`, `PrimaryColorLight`, and `SecondaryColor`. The mapping from Nordea colors to these variables are as follows:

* blueDeep -> PrimaryColor
* blueNordea -> PrimaryColorLight
* blueMedium -> SecondaryColor
* blueHaas -> SecondaryColor
* blueCloud -> SecondaryColor
