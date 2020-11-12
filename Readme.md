
WorkoutsMap

ToC:
* Install
* Build
* Run
* Bright and Beautiful Future
* Design and Development Resources and References

Install:
* Pull the repo to your local machine.
* Install pods on the directory for it's repo. https://cocoapods.org/

Build:
* Open app by clicking on its .xcworkspace file

Run:
* After xcode opens the app, run it clicking the play sign or hotkeys (ctrl+r)
* After clicking run, be sure you are in Xcode and not the simulator, on the toolbar, click Debug > Simulator Location > New York
* Go to the simulator, while the app mounts and opens
* Type "Dallas" in the search bark and hit enter or click return

Bright and Beautiful Future:
* Still figuring out a threading issue with Alamofire. I know it has to do with the response being asyncrounous and the apps ui executing before AF passes the values 
* Filter search bar text entry for non-alphanumerics, give error message in drop down label from search box accordingly ("not a valid entry")
* Search results table below the search box or a view controller that shows when the search box is touched
* Opening map app prompts when placemarker on the map is touch ("Would you like to open Google Maps?")
* Error alerts for various status codes ("Something went wrong. Please check your connection", "Something happened on our end. Please try again later.")
* Alerts for empty workout results ("There doesn't seem to be workouts near this location")

Design and Development Resources:
* Architecture: https://lucid.app/lucidchart/ef5a5b92-37c5-46a7-8a65-61a242931c8e/edit?beaconFlowId=C480992D96AAC96D&page=0_0#?folder_id=home&browser=icon
* Design: https://www.figma.com/file/E9uF9Y8GIbZ5XWKECREXLI/Camp-Gladiator-Colors?node-id=0%3A1
