import { Application } from "@hotwired/stimulus"
import Dropdown from "stimulus-dropdown"
import Clipboard from 'stimulus-clipboard'
import Audio from "./audio_controller"
import Tabs from "./tabs_controller"
import FooterPlayer from './footer_player_controller'
import Chart from './chart_controller'
//import GeoChart from './geo_chart_controller'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register("dropdown", Dropdown)
application.register("audio", Audio)
application.register("tabs", Tabs)
application.register("player", FooterPlayer)
application.register("clipboard", Clipboard)
application.register("chart", Chart)
// application.register("geo-chart", GeoChart)

export { application }




// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
