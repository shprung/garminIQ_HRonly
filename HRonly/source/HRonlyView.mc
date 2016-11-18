using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Sensor as HR;

class HRonlyView extends Ui.View {
	var lbl={};
	var timer=new Toybox.Timer.Timer();
	var devSet=Sys.getDeviceSettings();
	var t0=Sys.getTimer();
    
    function initialize() { 
    	View.initialize();
    	timer.start(new Toybox.Lang.Method(Ui, :requestUpdate), 500, true);
    }
    
	function setLbl(id){ lbl.put(id,findDrawableById(id));	}
	
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
        setLbl("tmHM"); setLbl("tmS"); setLbl("bat");  setLbl("HR");
    }
   
    function onUpdate(dc) {
        var tm = Sys.getClockTime();
        var h  = (devSet.is24Hour?tm.hour:tm.hour%12==0?12:tm.hour%12);
        var b  = Sys.getSystemStats().battery.format("%d");
        var t1 = Math.floor((Sys.getTimer()-t0)/1000);
        var bpm= HR.getInfo().heartRate;
        if (bpm==null) { 
        	bpm=tm.sec%2==1?"A ":"B "; // using font as graphics for 2 frame animation
        	if(t1%5==0 && t1<11) { HR.setEnabledSensors( [HR.SENSOR_HEARTRATE] ); }  // try to kick start the sensor
        } 
        else { bpm=bpm.format("%d"); }
		lbl["tmHM"].setText(h.format("%d")+':'+tm.min.format("%02d"));
        lbl["tmS"].setText(tm.sec.format("%02d"));
        h=Math.floor(t1/3600);
        t1-=h*3600;
        var m=Math.floor(t1/60);
        t1-=m*60;
        lbl["bat"].setText("Battery "+b+"%\nApp time "+h+":"+m.format("%02d")+":"+t1.format("%02d"));
        lbl["HR"].setText(bpm);
        View.onUpdate(dc);
    }
}
