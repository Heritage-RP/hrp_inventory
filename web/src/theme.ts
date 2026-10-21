// UI theme (fork patch, Heritage-RP/PRODUCTION-SERVER#476, #520). The client reads the replicated convar
// `hrp_ui_theme` and the resource declaring that theme (modules/theme/shared.lua) and sends `{ theme, stylesheet }` in
// the `init` message, then as `setTheme` when it changes. `neutral` (the default) is the upstream look; any declared
// theme gets the themed look of index.scss, coloured by the `--hrp-*` tokens of its stylesheet (added to the page
// here, once). In a browser, `?theme=<name>&themeStylesheet=<url>` picks one for development and screenshots.

export const DEFAULT_THEME = 'neutral';

export interface UiTheme {
  theme: string;
  stylesheet?: string | null;
}

/** The theme name `value` holds (case-insensitive, trimmed), `neutral` for anything else. */
export function themeOf(value: unknown): string {
  const name = typeof value === 'string' ? value.trim().toLowerCase() : '';
  return /^[a-z][a-z0-9-]*$/.test(name) ? name : DEFAULT_THEME;
}

/** Adds the theme's stylesheet once and sets `data-theme` on <html>; a bare name (no stylesheet) is kept as is. */
export function applyTheme(value: UiTheme | string | null | undefined): string {
  const data: UiTheme | { theme: unknown; stylesheet?: undefined } =
    typeof value === 'object' && value !== null ? value : { theme: value };
  const theme = themeOf(data.theme);
  const stylesheet = theme === DEFAULT_THEME ? null : data.stylesheet;

  if (stylesheet && !document.querySelector(`link[data-hrp-theme='${theme}']`)) {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = stylesheet;
    link.dataset.hrpTheme = theme;
    document.head.appendChild(link);
  }

  document.documentElement.dataset.theme = theme;
  return theme;
}

/** The theme a page URL forces (`?theme=<name>&themeStylesheet=<url>`), null without one. */
export function themeFromUrl(search: string): UiTheme | null {
  const params = new URLSearchParams(search);
  const theme = params.get('theme');
  return theme === null ? null : { theme: themeOf(theme), stylesheet: params.get('themeStylesheet') };
}
