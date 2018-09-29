/*
 * File: JLRecorder.java
 * Project: com.undsky.cordova.jlrecorder
 * File Created: 2018-09-28 08:51:19 am
 * Author: 姜彦汐 (jiangyanxi@live.com)
 * -----
 * Last Modified: 2018-09-28 09:46:01 am
 * Modified By: 姜彦汐 (jiangyanxi@live.com>)
 * -----
 * Copyright (c) 2018 www.undsky.com
 */

package com.undsky.cordova.jlrecorder;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import net.junzz.lib.recorder.Recorder;
import net.junzz.lib.recorder.RecorderFactory;
import net.junzz.lib.recorder.RecorderModel;

import android.app.Activity;
import java.io.File;
import java.io.IOException;

public class JLRecorder extends CordovaPlugin {

    private final RecorderFactory recorderFactory = new RecorderFactory();
    private final Recorder recorder = recorderFactory.newRecorder(RecorderModel.RECORDER_MODEL_MP3);
    private File file;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("start")) {
            String path = args.getString(0);
            this.start(path, callbackContext);
            return true;
        } else if (action.equals("stop")) {
            this.stop(callbackContext);
            return true;
        } else if (action.equals("destroy")) {
            this.destroy(callbackContext);
            return true;
        }
        return false;
    }

    private void start(String path, CallbackContext callbackContext) {
        if (path != null && path.length() > 0) {
            final Activity activity = cordova.getActivity();
            activity.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    file = new File(path);
                    try {
                        if (file != null) {
                            recorder.prepare(file);
                            new Thread(recorder::start).start();
                            callbackContext.success(path);
                        } else {
                            callbackContext.error("path is not exists");
                        }
                    } catch (IOException e) {
                        callbackContext.error("recorder prepare failure");
                    }
                }
            });
        } else {
            callbackContext.error("need path argument");
        }
    }

    private void stop(CallbackContext callbackContext) {
        recorder.stop();
        callbackContext.success();
    }

    private void destroy(CallbackContext callbackContext) {
        recorder.release();
        if (file != null) {
            file.delete();
        }
        callbackContext.success();
    }
}
