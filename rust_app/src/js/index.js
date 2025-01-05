/** Invoke object for the whole app */
const invoke = window.__TAURI__.core.invoke;

/** Global access to the array of overlays */
let overlays = ["ssbu", "kart", "overwatch", "rocketLeague", "val", "lol", "siege", "strikers"];

/** Map of the sport titles */ 
let nameMap = {
    "ssbu"         : "Super Smash Bros. Ultimate",
    "kart"         : "Mario Kart 8 Deluxe",
    "overwatch"    : "Overwatch",
    "rocketLeague" : "Rocket League",
    "val"          : "Valorant",
    "siege"        : "Rainbow 6 Siege",
    "strikers"     : "Omega Strikers"
};

/**
 * Sets the color of the app from the config
 * @async
 */
async function setupApp() {
    let color = await invoke('read_config_json', { "key" : "appTheme" }).then((value) => overlay = Array.from(value).filter(char => char !== "\"").join(''));
    
    setColor(color, true);
}