using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Time;
using Toybox.Time.Gregorian;

class DataArea extends Ui.Drawable {

	private var mRow1Y;
	private var mRow2Y;

	private var mLeftGoalType;
	private var mLeftGoalIsValid;
	private var mLeftGoalCurrent;
	private var mLeftGoalMax;

	private var mMiddleGoalType;
	private var mMiddleGoalIsValid;
	private var mMiddleGoalCurrent;
	private var mMiddleGoalMax;

	private var mRightGoalType;
	private var mRightGoalIsValid;
	private var mRightGoalCurrent;
	private var mRightGoalMax;

	private var mGoalIconY;
	private var mGoalIconLeftX;
	private var mGoalIconMiddleX;
	private var mGoalIconRightX;

	function initialize(params) {
		Drawable.initialize(params);

		mRow1Y = params[:row1Y];
		mRow2Y = params[:row2Y];

		mGoalIconY = params[:goalIconY];
		mGoalIconLeftX = params[:goalIconLeftX];
		mGoalIconMiddleX = params[:goalIconMiddleX];
		mGoalIconRightX = params[:goalIconRightX];
	}

	function setGoalValues(leftType, leftValues, rightType, rightValues, 
	                       middleType, middleValues) {
		mLeftGoalType = leftType;
		mLeftGoalIsValid = leftValues[:isValid];

		if (leftValues[:isValid]) {
			mLeftGoalCurrent = leftValues[:current].format(INTEGER_FORMAT);
			if (mLeftGoalType == GOAL_TYPE_BATTERY) {
				mLeftGoalMax = "%";
			} else {
				mLeftGoalMax = leftValues[:max].format(INTEGER_FORMAT);
			}
		} else {
			mLeftGoalCurrent = null;
			mLeftGoalMax = null;
		}

		mRightGoalType = rightType;
		mRightGoalIsValid = rightValues[:isValid];

		if (rightValues[:isValid]) {
			mRightGoalCurrent = rightValues[:current].format(INTEGER_FORMAT);
			if (mRightGoalType == GOAL_TYPE_BATTERY) {
				mRightGoalMax = "%";
			} else {
				mRightGoalMax = rightValues[:max].format(INTEGER_FORMAT);
			}
		} else {
			mRightGoalCurrent = null;
			mRightGoalMax = null;
		}
		
		mMiddleGoalType = middleType;
		mMiddleGoalIsValid = middleValues[:isValid];
		if (mMiddleGoalIsValid) {
			mMiddleGoalCurrent = middleValues[:current].format(INTEGER_FORMAT);
			if (mMiddleGoalType == GOAL_TYPE_BATTERY) {
				mMiddleGoalMax = "%";
			} else {
				mMiddleGoalMax = middleValues[:max].format(INTEGER_FORMAT);
			}
		} else {
			mMiddleGoalCurrent = null;
			mMiddleGoalMax = null;
		}
	}

	function draw(dc) {
		drawGoalIcon(dc, mGoalIconLeftX, mLeftGoalType, mLeftGoalIsValid, Graphics.TEXT_JUSTIFY_CENTER, mLeftGoalCurrent, mLeftGoalMax);
		drawGoalIcon(dc, mGoalIconMiddleX, mMiddleGoalType, mMiddleGoalIsValid, Graphics.TEXT_JUSTIFY_CENTER, mMiddleGoalCurrent, mMiddleGoalMax);  
		drawGoalIcon(dc, mGoalIconRightX, mRightGoalType, mRightGoalIsValid, Graphics.TEXT_JUSTIFY_CENTER, mRightGoalCurrent, mRightGoalMax);  
/*
		var city = App.getApp().getProperty("LocalTimeInCity");

		// Check for has :Storage, in case we're loading settings in the simulator from a different device.
		// #78 Setting with value of empty string may cause corresponding property to be null.
		if ((city != null) && (city.length() != 0) && (App has :Storage)) {
			//drawTimeZone();
			var cityLocalTime = App.Storage.getValue("CityLocalTime");

			// If available, use city returned from web request; otherwise, use raw city from settings.
			// N.B. error response will NOT contain city.
			if ((cityLocalTime != null) && (cityLocalTime["city"] != null)) {
				city = cityLocalTime["city"];
			}

			// Time zone 1 city.
			dc.setColor(gMonoDarkColour, Gfx.COLOR_TRANSPARENT);
			dc.drawText(
				locX + (width / 2),
				mRow1Y,
				gNormalFont,
				// Limit string length.
				city.substring(0, 10),
				Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
			);

			// Time zone 1 time.
			var time;
			if (cityLocalTime) {

				// Web request responded with server error e.g. unknown city.
				if (cityLocalTime["error"] != null) {

					time = "???";

				// Web request responded with time zone data for city.
				} else {
					var timeZoneGmtOffset;

					// Use next GMT offset if it's now applicable (new data will be requested shortly).
					if ((cityLocalTime["next"] != null) && (Time.now().value() >= cityLocalTime["next"]["when"])) {
						timeZoneGmtOffset = cityLocalTime["next"]["gmtOffset"];
					} else {
						timeZoneGmtOffset = cityLocalTime["current"]["gmtOffset"];
					}
					timeZoneGmtOffset = new Time.Duration(timeZoneGmtOffset);
					
					var localGmtOffset = Sys.getClockTime().timeZoneOffset;
					localGmtOffset = new Time.Duration(localGmtOffset);

					// (Local time) - (Local GMT offset) + (Time zone GMT offset)
					time = Time.now().subtract(localGmtOffset).add(timeZoneGmtOffset);
					time = Gregorian.info(time, Time.FORMAT_SHORT);
					time = App.getApp().getView().getFormattedTime(time.hour, time.min);
					time = time[:hour] + ":" + time[:min] + time[:amPm]; 
				}

			// Awaiting response to web request sent by BackgroundService.
			} else {
				time = "...";
			}

			dc.setColor(gMonoLightColour, Gfx.COLOR_TRANSPARENT);
			dc.drawText(
				locX + (width / 2),
				mRow2Y,
				gNormalFont,
				time,
				Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
			);

		} else {
*/		
			drawGoalValues(dc, mGoalIconLeftX, mLeftGoalCurrent, mLeftGoalMax, Graphics.TEXT_JUSTIFY_CENTER);
			drawGoalValues(dc, mGoalIconRightX, mRightGoalCurrent, mRightGoalMax, Graphics.TEXT_JUSTIFY_CENTER);
			drawGoalValues(dc, mGoalIconMiddleX, mMiddleGoalCurrent, mMiddleGoalMax, Graphics.TEXT_JUSTIFY_CENTER);
/*
		}
*/		
	}

	function drawGoalIcon(dc, x, type, isValid, align, currentValue, maxValue) {
		var icon = {
			GOAL_TYPE_BATTERY => "9",
			GOAL_TYPE_CALORIES => "6",
			GOAL_TYPE_STEPS => "0",
			GOAL_TYPE_FLOORS_CLIMBED => "1",
			GOAL_TYPE_ACTIVE_MINUTES => "2",
		}[type];

		if (isValid) {
			if (type == GOAL_TYPE_BATTERY) {
				dc.setColor(gThemeColour, Gfx.COLOR_TRANSPARENT);
			} else {
				var h = 24; // icon height
				var correction = (align == Gfx.TEXT_JUSTIFY_CENTER ? h / 2 : 0);
				dc.setColor(gMeterBackgroundColour, gMeterBackgroundColour);
				dc.fillRectangle(x - correction, mGoalIconY+1, h, h);
			
				//draw filled rectangle to represent the completeness level
				var p = currentValue.toNumber() * 1.0 / maxValue.toNumber();
				if (p > 1) {
					p = 1;
				}
				p = (p * h).toLong();
				dc.setColor(gThemeColour, gThemeColour);
				dc.fillRectangle(x - correction, mGoalIconY+1+(h-p), h, p);
	
				//create and draw the clipping mask
				dc.setColor(Gfx.COLOR_TRANSPARENT, gBackgroundColour);		
			}			
		} else {
			dc.setColor(gMeterBackgroundColour, Gfx.COLOR_TRANSPARENT);
		}

		
		dc.drawText(
			x,
			mGoalIconY,
			gIconsFont,
			icon,
			align
		);
	}

	function drawGoalValues(dc, x, currentValue, maxValue, align) {
		var divide = false;
		if (currentValue != null) {
			if (isNumeric(currentValue)) {
				divide = currentValue.toNumber() > 1000;
			}
		}
		if (!divide) {
			if (maxValue != null) {
				if (isNumeric(maxValue)) {
					divide = maxValue.toNumber() > 1000;
				}
			}
		}
		
		if (currentValue != null) {
			dc.setColor(gMonoLightColour, Gfx.COLOR_TRANSPARENT);
			dc.drawText(
				x,
				mRow1Y,
				gNormalFont,
				divide? (currentValue.toNumber() / 1000.0).format("%.1f") : currentValue,
				align | Graphics.TEXT_JUSTIFY_VCENTER
			); 
		}

		if (maxValue != null) {
			dc.setColor(gMonoDarkColour, Gfx.COLOR_TRANSPARENT);
			dc.drawText(
				x,
				mRow2Y,
				gNormalFont,
				divide? (maxValue.toNumber() / 1000.0).format("%.1f") : maxValue,
				align | Graphics.TEXT_JUSTIFY_VCENTER
			);
		}
	}
	
    function isNumeric(value) {
        if (value == null) {
            return false;
        }
        for (var i = 0; i < value.length(); i++) {
            var x = value.substring(i, i+1);
            if (!(x.equals("0") || x.equals("1") || x.equals("2") || x.equals("3") || x.equals("4") || x.equals("5") || x.equals("6") || x.equals("7") || x.equals("8") || x.equals("9"))) { 
                return false;
            }
        }
        return value.length() > 0;
    }
}
