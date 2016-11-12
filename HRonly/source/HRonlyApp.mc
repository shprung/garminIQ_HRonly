using Toybox.Application as App;
using Toybox.WatchUi as Ui;

class HRonlyApp extends App.AppBase {

	var fileRecorder;
	
    function initialize() {
        AppBase.initialize();
        fileRecorder = ActivityRecording.createSession({:name=>"niu"});
    }

    function onStart(state) { fileRecorder.start(); }

    function onStop(state) {
    	if(fileRecorder.isRecording()){
	    	fileRecorder.stop();
	    	fileRecorder.discard();
    	}
    }

    function getInitialView() {
        return [ new HRonlyView() ]; 
    }

}
