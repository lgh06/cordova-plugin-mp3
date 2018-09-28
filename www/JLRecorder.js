/*
 * File: JLRecorder.js
 * Project: com.undsky.cordova.jlrecorder
 * File Created: 2018-09-28 08:22:19 am
 * Author: 姜彦汐 (jiangyanxi@live.com)
 * -----
 * Last Modified: 2018-09-28 09:46:15 am
 * Modified By: 姜彦汐 (jiangyanxi@live.com>)
 * -----
 * Copyright (c) 2018 www.undsky.com
 */

var exec = require('cordova/exec');

module.exports = {
    /**
     *录音
     *
     * @param {*} path mp3 存储路径
     * @param {*} success
     * @param {*} error
     */
    start: function (path, success, error) {
        exec(success, error, 'JLRecorder', 'start', [path]);
    },
    /**
     *暂停
     *
     * @param {*} success
     * @param {*} error
     */
    stop: function (success, error) {
        exec(success, error, 'JLRecorder', 'stop', []);
    },
    /**
     *销毁
     *
     * @param {*} success
     * @param {*} error
     */
    destroy: function (success, error) {
        exec(success, error, 'JLRecorder', 'destroy', []);
    },
};
