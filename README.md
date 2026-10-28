# elm-components

## Running locally
Run `npm ci` and then `npm start` from the project root. The component explorer runs at http://localhost:3009.

Run `npm run build` for a production build in `dist/`, and `npm run verify-lint` to review all Elm sources.

The components, explorer, and stories share `src/` and a single root npm and Elm application configuration.

## Integration

- Take a look at https://github.com/SGFinansAS/sgfinans24beta/pull/649 and https://github.com/SGFinansAS/sgfinans24beta/pull/656


## Themes

Theming is supported through CSS variables: https://developer.mozilla.org/en-US/docs/Web/CSS/Using_CSS_custom_properties

We currently have three css variables for theming: `PrimaryColor`, `PrimaryColorLight`, and `SecondaryColor`. The mapping from Nordea colors to these variables are as follows:

* blueDeep -> PrimaryColor
* blueNordea -> PrimaryColorLight
* blueMedium -> SecondaryColor
* blueHaas -> SecondaryColor
* cloudBlue -> SecondaryColor

### Icons 

Icons and general instructions for implementation can be found here https://www.figma.com/design/WR6tZiWCWXAAjSPck8bUp1/Nordea-icons?node-id=717-1338&t=9TNhGs80Dg8kyQ6s-0. 
