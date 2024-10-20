function DatetimeToString(timestamp) {
    ts = new Date(timestamp);

    year = ts.getFullYear().toString();

    month = "00" + (ts.getMonth() + 1).toString();
    month = month.substring(month.length - 2);

    day = "00" + ts.getDate().toString();
    day = day.substring(day.length - 2);

    hour = "00" + ts.getHours().toString();
    hour = hour.substring(hour.length - 2);

    minute = "00" + ts.getMinutes().toString();
    minute = minute.substring(minute.length - 2);

    second = "00" + ts.getSeconds().toString();
    second = second.substring(second.length - 2);

    retVal = year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second;

    offset = ts.getTimezoneOffset() * -1;

    if (offset == 0) {
        retVal = retVal + "+00:00";
        return retVal;
    } else if(offset > 0) {
        retVal = retVal + "+";
    } else if(offset < 0) {
        retVal = retVal + "-";
        offset = offset * -1;
    }

    offsetHours = "00" + (offset / 60).toString();
    offsetHours = offsetHours.substring(offsetHours.length - 2);

    offsetMinutes = "00" + (offset % 60).toString();
    offsetMinutes = offsetMinutes.substring(offsetMinutes.length - 2);

    retVal += offsetHours + ":" + offsetMinutes;

    return retVal;
}

function getNowForDatetimeLocal() {
    var now = new Date();
    now.setMinutes(now.getMinutes() - now.getTimezoneOffset());
    now = now.toISOString().slice(0,19);

    // console.log(now);

    return now;
}