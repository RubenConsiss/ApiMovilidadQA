
const moment = require('moment-timezone');

//BDO week starts on Monday
const BdoWeekday = [];
BdoWeekday[0] = "LUN";
BdoWeekday[1] = "MAR";
BdoWeekday[2] = "MIE";
BdoWeekday[3] = "JUE";
BdoWeekday[4] = "VIE";
BdoWeekday[5] = "SAB";
BdoWeekday[6] = "DOM";

const BdoMonths = [
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Julio",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre"
]

function getBDOWeeksRangesForDevice(year, month) {
  const mondays = getBDOMondaysFromMonthStartMonday(year, month)

  let monthsWeeks = {
    "nombre_del_rango": `${BdoMonths[month - 1]} ${year}`,
    "mes": month,
    "anio": year,
    "semanas": getBDOWeeksDetailsForDevice(mondays, month)
  }

  return monthsWeeks;
}

function getBDOWeeksDetailsForDevice(dates, month) {
  return dates.map(monday => {
    const aux = new Date(monday)
    aux.setDate(monday.getDate() + 6)

    monday = moment(monday).format("YYYY-MM-DD")
    const nextDate = moment(aux.getTime()).format("YYYY-MM-DD")

    return {
      "nombre_de_la_semana": getWeekRangeName(monday, nextDate, month),
      "fechas_de_la_semana": [monday, nextDate],
      "dias_de_la_semana": getBDODatesBeetweenStartAndNextDate(monday, nextDate)
    }
  })
}

function getBDODatesBeetweenStartAndNextDate(initDate, nextDate) {
  let dias_de_la_semana = [];

  while (initDate <= nextDate) {
    dias_de_la_semana.push(initDate);
    initDate = getNextDate(initDate)
  }

  return dias_de_la_semana;
}

function getBDOMondaysFromMonthStartMonday(year, month) {
  const stringDate = `${year}-${month}-01T10:00:00Z`;

  var date = new Date(stringDate),
    month = date.getMonth(),
    mondays = [];

  date.setDate(1);

  // Get the first Monday in the month
  while (date.getDay() !== 1) {
    date.setDate(date.getDate() + 1);
  }

  // Get all the other Mondays in the month
  while (date.getMonth() === month) {
    mondays.push(new Date(date.getTime()));
    date.setDate(date.getDate() + 7);
  }

  return mondays;
}

function getWeekRangeName(startDate, nextDate, month) {
  const _startDate = moment(startDate)
  const _nextDate = moment(nextDate)

  let nombre_de_la_semana = `${_startDate.date()}-${_nextDate.date()} `
  if (month == _nextDate.month() + 1) {
    nombre_de_la_semana += `${BdoMonths[month - 1]}`
  } else {
    nombre_de_la_semana = `${_startDate.date()} ${BdoMonths[month - 1]}-${_nextDate.date()} ${BdoMonths[_nextDate.month()]}`
  }
  //nombre_de_la_semana += month == _nextDate.month() + 1 ? `${BdoMonths[month - 1]}` : `${BdoMonths[month - 1]}/${BdoMonths[_nextDate.month()]}`

  return nombre_de_la_semana
}

function getBDOCurrentDate(tz) {
  tz = tz || process.env.TZ;
  let date = moment().tz(tz).format("YYYY-MM-DD");
  return date;
}

function getBDOUTCCurrentDate() {
  let date = moment().format("YYYY-MM-DD");
  return date;
}

function getBDOCurrentTimestamp(tz) {
  tz = 'UTC';//tz || process.env.TZ;
  let date = moment().tz(tz).format("YYYY-MM-DD HH:mm:ss");
  return date;
}

function getBDOUTCCurrentTimestamp() {
  let date = moment().format("YYYY-MM-DD HH:mm:ss");
  return date;
}

function getBDOFirstDayOfWeek(date, from) {




  date = date || moment().format("YYYY-MM-DD");
  //Default start week from 'Sunday'. You can change it yourself.
  //BDO week starts on Monday
  from = from || 'LUN';//'Monday' // 'Sunday'; 
  var index = BdoWeekday.indexOf(from);
  var start = index >= 0 ? index : 0;

  var d = new Date(date);
  var day = d.getDay();
  var diff = d.getDate() - day + (start > day ? start - 7 : start);
  d.setDate(diff);
  // example d.toISOString = 2018-08-05T00:00:00.000Z
  return d.toISOString().split('T')[0];
};

function firstOfTheWeek(date, from) {
  return date.startOf('isoWeek').format("YYYY-MM-DD");
}
function lastOfWeek(date, from) {
  return date.endOf('isoWeek').format("YYYY-MM-DD");
}
function getSimpleFormat(date) {
  return moment(date).format("YYYY-MM-DD");
}

function getBDOLastDayOfWeek(date, from) {
  date = date || moment().format("YYYY-MM-DD");
  //BDO week ends on Sunday
  from = from || 'LUN'; // 'Monday';// 'Sunday';
  var index = BdoWeekday.indexOf(from);
  var start = index >= 0 ? index : 0;

  var d = new Date(date);
  var day = d.getDay();
  var diff = d.getDate() - day + (start > day ? start - 1 : 6 + start);
  d.setDate(diff);
  return d.toISOString().split('T')[0];
};

function getBDOWeekDaysArray(date) {
  date = date || moment().format("YYYY-MM-DD");

  var d = new Date(date);
  //
  let dates = [];
  for (let num = 0; num < 7; num++) {
    day = d.getDay();
    diff = d.getDate() - day + num;
    d.setDate(diff);
    dates.push(d.toISOString().split('T')[0]);
  }
  return dates;
};

function getBDOFormattedDate(date, lang, format, all_uppercase = false, use_raw_date = false) {
  fmtDate = date + (use_raw_date ? "" : " 00:00:00");
  moment.locale(lang);
  fdate = moment(fmtDate).format(format).toLowerCase();
  if (all_uppercase) {
    //return all upercase
    return fdate.replace(/\w\S*/g,
      function (txt) {
        return txt.toUpperCase();
      });
  } else {
    //capitalize the first letter of each word in a string
    return fdate.replace(/\w\S*/g,
      function (txt) {
        return txt.charAt(0).toUpperCase() +
          txt.substr(1).toLowerCase();
      });
  }
}

function getBDOFormat(date, format) {
  fmtDate = date + " 00:00:00";
  fdate = moment(fmtDate).format(format);
  return fdate;
}

function isLeapYear(year) {
  return ((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0);
}

function isDateLessThanCurrent(vdate) {
  let dCurrentDay = moment().format("YYYYMMDD");
  fdate = vdate.replace(/-/g, "");
  return ((fdate * 1) < (dCurrentDay * 1));
}

function isDateGreatherThanCurrent(vdate) {
  let dCurrentDay = moment().format("YYYYMMDD");
  fdate = vdate.replace(/-/g, "");
  return ((fdate * 1) > (dCurrentDay * 1));
}

function isWeekGreatherThanCurrent(week, year) {
  current_date = getBDOUTCCurrentDate();
  [dCurrentWeek, dCurrentYear] = getWeekAndYearFromDate(current_date);
  //let dCurrentWeek =  moment().format("w");
  week = ('00' + week).slice(-2);
  dCurrentWeek = ('00' + dCurrentWeek).slice(-2);
  //dCurrentYear =  moment().format("YYYY");
  dCurrent = (dCurrentYear + "" + dCurrentWeek) * 1;
  dWeek = (year + "" + week) * 1;
  return (dWeek > dCurrent);
}

function isMonthGreatherThanCurrent(month, year) {
  let dCurrentMonth = moment().format("MM");
  month = ('00' + month).slice(-2);
  dCurrentMonth = ('00' + dCurrentMonth).slice(-2);
  dCurrentYear = moment().format("YYYY");
  dCurrent = (dCurrentYear + "" + dCurrentMonth) * 1;
  dMonth = (year + "" + month) * 1;
  return (dMonth > dCurrent);
}

//return example: [ 'SEMANA 5', '29 ENERO-4 FEBRERO', '2018-01-29', '2018-02-04' ]
function formatWeekStartEndDays(nweek, nyear, device) {
  week_days_fmt = null;
  if (nweek && nyear) {
    var start_date =
      moment(nweek + " " + nyear, "WW GGGG").format('YYYY-MM-DD');//ISO
    var end_date =
      moment(start_date).add(6, 'days').format('YYYY-MM-DD');
    start_month =
      bdoDates.getBDOFormattedDate(
        start_date,
        "es",
        "MM",
        true
      );//Monday
    end_month =
      bdoDates.getBDOFormattedDate(
        end_date,
        "es",
        "MM",
        true
      );//Sunday
    titleWeek = 'SEMANA ';
    fmtDt = "D MMMM";
    if (['1', '2'].includes(device)) {//is handheld or tablet
      titleWeek = 'SEM ';
      fmtDt = "D MMM";
    }

    if (start_month == end_month) {
      week_days_fmt = bdoDates.getBDOFormattedDate(
        start_date,
        "es",
        "D",
        true
      ) + '-' + bdoDates.getBDOFormattedDate(
        end_date,
        "es",
        fmtDt,
        true
      ); //+' '+bdoDates.getBDOFormattedDate(
      //end_date, 
      //"es", 
      //"YYYY",
      //true
      //);//Monday
    } else {
      week_days_fmt = bdoDates.getBDOFormattedDate(
        start_date,
        "es",
        fmtDt,
        true
      ) + '-' + bdoDates.getBDOFormattedDate(
        end_date,
        "es",
        fmtDt,
        true
      ); //+' '+bdoDates.getBDOFormattedDate(
      // end_date, 
      // "es", 
      // "YYYY",
      // true
      //);//Sunday
    }
    week_days_fmt = [titleWeek + nweek, week_days_fmt, start_date, end_date];
  }
  return week_days_fmt;
}

//return example: [ '2', '2018', 'FEBRERO', '2018-02-01', '2018-02-28' ]
function formatMonthStartEndDays(nmonth, nyear, device) {
  month_days_fmt = null;
  if (nmonth && nyear) {
    start_date = moment([nyear, nmonth - 1, 01]);
    start_date_fmt = start_date.format('YYYY-MM-DD');
    var end_date = start_date.clone().endOf('month').format("YYYY-MM-DD");
    fmtMonth = "MMMM";
    if (['1', '2'].includes(device)) {//is handheld or tablet
      fmtMonth = "MMM";
    }
    month_days_fmt = [
      nmonth,
      nyear,
      bdoDates.getBDOFormattedDate(
        start_date_fmt,
        "es",
        fmtMonth,
        true
      ),
      start_date_fmt,
      end_date
    ];
  }
  return month_days_fmt;
}

function getNextDate(date, format = 'YYYY-MM-DD', next_days = 1) {
  let next_date =
    moment(date).add(next_days, 'days').format(format);
  return next_date;
}

function getPrevDate(date, format = 'YYYY-MM-DD', prev_days = 1) {
  let prev_date =
    moment(date).subtract(prev_days, 'days').format(format);
  return prev_date;
}

function getWeekAndYearFromDate(date, lang = "es") {
  if (!date) {
    return null;
  }
  fmtDate = date + " 00:00:00";
  moment.locale(lang);
  nWeek = moment(fmtDate).format("w").toLowerCase();
  nYear = moment(fmtDate).weekYear();
  return [nWeek, nYear];
}

function getReportData(
  checklist_id,
  end_date,
  d_type = "D", // D , S , M
  tipo_cliente = 1, //1=handheld, 2=tablet, 3=web
  d_subtract = 7, //Diario= 7/14 days, Semanal= 2/4 weeks, Mensual= 3/6 months
  bitacora_respuestas = {},
  lang = "es",
  modulo = null
) {
  let days_array = [],
    day = null,
    first_day = null,
    last_day = null,
    meses_id = [],
    meses_array = [],
    semanas_id = [],
    semanas_array = [],
    existe_day = false,
    existe_month = false,
    existe_week = false,
    dbg = false;
  //
  if (dbg) console.log("[GRD:294] Start getReportData (", checklist_id, d_type, tipo_cliente, d_subtract, ")...");
  moment.locale(lang);
  const iend =
    moment(end_date, 'YYYY-MM-DD');
  //
  switch (d_type) {
    case "D":
      d_range = 'days';
      break;
    case "S":
      d_range = 'weeks';
      break;
    case "M":
      d_range = 'months';
      break;
  }
  const istart = //substract by 1 to include end date/week/month
    moment(end_date, 'YYYY-MM-DD').subtract(d_subtract - 1, d_range);
  //
  first_day = istart.format('YYYY-MM-DD');
  last_day = iend.format('YYYY-MM-DD');
  current_date = getBDOUTCCurrentDate();
  current_month = moment().format("M"),
    [current_week, current_year] = getWeekAndYearFromDate(current_date);
  selected_year = iend.weekYear();
  selected_week = iend.format('w');
  selected_month = iend.format('M');
  if (dbg) console.log("[GRD:299] First day = " +
    first_day +
    " , last day = " +
    last_day +
    " , selected year/month/week = ", selected_year, selected_month, selected_week);
  //
  if (dbg) console.log("[GRD:309] bitacora_respuestas = " + JSON.stringify(bitacora_respuestas));

  for (var m = moment(istart);
    m.isBefore(moment(iend).add(1, 'days'));
    m.add(1, 'days')) {
    abbr = m.format('dddd');//'ddd' = Lun.
    nday = m.format('DD');
    dt = m.format('YYYY-MM-DD');
    //
    respId = checklist_id + "-" + dt;
    if (bitacora_respuestas[respId]) {//dt
      existe_day = true;
      if (dbg) console.log("[GRD:320] Existe respuestas para dia(", respId, "):", dt);
    } else {
      //if(dbg) console.log("[GRD:322] No Existe respuestas para dia(",respId,"):", dt);
    }
    //
    //calculate year-month
    numyear = m.format('YYYY');
    nmonth = m.format('M');
    month_name = m.format('MMMM');//month name
    //calculate year-week
    nyear = nYear = m.weekYear();//year in 4 digits
    nweek = m.format('w');//week in one digit
    //
    titulo_mes = month_name.charAt(0).toUpperCase() +
      month_name.slice(1) +
      ' ' + numyear;
    //
    mes_id = numyear + '-' + nmonth;
    month_info = formatMonthStartEndDays(nmonth, numyear, tipo_cliente);

    //check if mes_id exists
    respId = checklist_id + "-" + nmonth;
    if (bitacora_respuestas[respId]) {//nmonth
      existe_month = true;
      if (dbg) console.log("[GRD:344] Existe respuestas para mes(", respId, dt, "):", nmonth);
    } else {
      //if(dbg) console.log("[GRD:346] No Existe respuestas para mes(", respId, dt, "):", nmonth);                
    }
    if (!meses_id.includes(mes_id)) {
      meses_id.push(mes_id);
      is_selected = (
        ((selected_year == numyear) && (selected_month == nmonth)) ?
          true :
          false
      );
      is_current_month = (
        ((current_year == numyear) && (current_month == nmonth)) ?
          true :
          false
      );

      switch (modulo) {
        case "utensilios":
          first_day = istart.format('YYYY-MM-[01]');
          meses_array.push(
            {
              "dt": "" + (is_selected ? last_day : month_info[4]),
              "yr": "" + numyear,
              "nm": "" + nmonth,
              "sl": is_selected,
              "cr": is_current_month,
              "mt": month_info[1],
              "tl": month_info[2]
              //"sf":existe_month
            }
          );
          last_day = iend.clone().endOf('month').format("YYYY-MM-DD");
          break;
        default:
          meses_array.push(
            {
              "ck": "" + checklist_id,
              "yr": "" + numyear,
              "dt": "" + (is_selected ? last_day : month_info[4]),
              "nm": "" + nmonth,
              "sl": is_selected,
              "cr": is_current_month,
              "mt": month_info[1],
              "tl": month_info[2],
              "st": "",
              "sf": existe_month
            }
          );
          break;
      }

    }
    //
    semana_id = nyear + '-' + nweek;
    week_info = formatWeekStartEndDays(nweek, nyear, tipo_cliente);
    //check if semana_id exists
    respId = checklist_id + "-" + nweek;
    if (bitacora_respuestas[respId]) {//nweek
      existe_week = true;
      if (dbg) console.log("[GRD:425] Existe respuestas para semana(", respId, dt, "):", nweek);
    } else {
      //if(dbg) console.log("[GRD:377] No Existe respuestas para semana(", respId, dt,  "):", nweek);
    }
    if (!semanas_id.includes(semana_id)) {
      semanas_id.push(semana_id);
      is_selected = (selected_week == nweek ? true : false);
      is_current_week = (
        ((current_year == nyear) && (current_week == nweek)) ?
          true :
          false
      );
      semanas_array.push(
        {
          "ck": "" + checklist_id,
          "yr": "" + nyear,
          "dt": "" + (is_selected ? last_day : week_info[3]),
          "nm": "" + nweek,
          "sl": is_selected,
          "cr": is_current_week,
          "mt": week_info[0],
          "tl": week_info[1],
          "st": "",
          "sf": existe_week
        }
      );
    }
    //
    day = {
      "ck": "" + checklist_id,
      "yr": "" + dt.substr(0, 4),
      "dt": "" + dt,
      "nm": "",
      "sl": (dt == end_date ? true : false),
      "cr": (current_date == dt ? true : false),
      "mt": abbr.charAt(0).toUpperCase() + abbr.slice(1),
      "tl": abbr.charAt(0).toUpperCase(),
      "st": "" + nday,
      "sf": existe_day
    };
    days_array.push(day);
    existe_day = false;
    existe_month = false;
    existe_week = false;
    //if(dbg) console.log("[GRD:412] -----------------------------------");
  }

  if (dbg) console.log("[GRD:472] End getReportData.");
  return [
    first_day,
    last_day,
    days_array,
    semanas_array,
    meses_array
  ];
}

function getEndOfMonth(fdate) {
  if (fdate) {
    fmtDate = fdate + " 00:00:00";
    const endCalendarDate = moment(fmtDate).endOf('month').format('YYYY-MM-DD');
    return endCalendarDate;
  }
  return;
}

function buildMonthlyCalendarData(start_date, end_date, lang = "es") {
  fmtStDate = start_date + " 00:00:00";
  fmtEndDate = end_date + " 00:00:00";
  moment.locale(lang);

  const startCalendarDate = moment(fmtStDate).startOf('month');
  const endCalendarDate = moment(fmtEndDate).endOf('month');
  let calendar_data = [];

  for (var m = moment(startCalendarDate);
    m.isBefore(moment(endCalendarDate));
    m.add(1, "month")) {
    calendar_data.push({
      "dt": m.format('YYYY-MM') + "-" + m.daysInMonth(),
      "yr": m.format('YYYY'),
      "mn": m.format('MMMM')
    });
  }

  return calendar_data;
}

function buildCalendar(checklist_id,
  date,//YYYY-MM-DD
  days_per_week = 7,
  bitacora_respuestas = {},
  lang = "es") {
  const dbg = false;
  fmtDate = date + " 00:00:00";
  //moment.locale(lang);

  if (dbg) console.log("[GBD:522] Start buildCalendar... ",
    checklist_id,
    date,
    days_per_week,
    fmtDate);

  const startWeekDate = moment(fmtDate).startOf('week');
  const startMonthDate = moment(fmtDate).startOf('month');
  const endMonthDate = moment(fmtDate).endOf('month');
  const startMonthWeekDate = moment(startMonthDate).startOf('week');
  const startYear = moment(startMonthWeekDate).year();
  const endMonthWeekDate = moment(endMonthDate).endOf('week');
  const endYear = moment(endMonthWeekDate).year();
  const endWeekDate = moment(fmtDate).endOf('week');
  const currentMonthName = moment(fmtDate).format('MMMM');

  if (dbg) console.log("Start Month Week Date: ", startMonthWeekDate);
  if (dbg) console.log("End Month Week Date: ", endMonthWeekDate);

  if (dbg) console.log("Start Week Date: ", startYear, startWeekDate);
  if (dbg) console.log("End Week Date: ", endYear, endWeekDate);

  const startWeek = moment(fmtDate).startOf('month').week();
  const endWeek = moment(fmtDate).endOf('month').week();

  if (dbg) console.log("Start Week: ", startYear, startWeek);
  if (dbg) console.log("End Week: ", endYear, endWeek);

  let calendar = [];
  let day_counter = 0;
  let week_counter = 0;
  let start_date = null;
  let week_data = [];
  let calendar_data = {};
  let current_date = getBDOUTCCurrentDate();

  for (var m = moment(startMonthWeekDate);
    m.isBefore(moment(endWeekDate));//endMonthWeekDate //.add(1, 'days')
    m.add(1, "days")) {
    day_counter++;
    day_name = m.format('dddd');//'dddd' = lunes
    day_name_abbr = m.format('ddd');//'ddd' = lun.
    day_name_letter = day_name_abbr.substring(0, 1);
    //month_name_abbr = m.format('MMM');//'MMM' = Feb.
    month_name = m.format('MMMM');//'MMMM' = Febrero
    nday = m.format('DD');
    dt = m.format('YYYY-MM-DD');
    year = m.weekYear();
    week = m.week(); //left_pad(m.week(), 2);

    existe_day = false;
    respId = checklist_id + "-" + dt;
    if (bitacora_respuestas[respId]) {
      existe_day = true;
    }

    if (dbg) console.log("[BC:578: ", dt, "] ", day_name_letter, day_name_abbr, nday, year, week);

    day = {
      "ck": "" + checklist_id,
      "yr": year, //""+dt.substr(0, 4),
      "dt": "" + dt,
      "mn": month_name,
      "wk": week,
      "nm": "",
      "sl": (dt == date ? true : false),
      "cr": (current_date == dt ? true : false),
      "mt": day_name, //abbr.charAt(0).toUpperCase() + abbr.slice(1),
      "tl": day_name_letter, //abbr.charAt(0).toUpperCase(),
      "st": "" + nday,
      "sf": existe_day
      //dna:day_name_abbr, 
      //mna:month_name_abbr,
    };
    week_data.push(day); //[dt]
    calendar_data[dt] = day;

    if (day_counter < days_per_week) {
      if (day_counter == 1) {
        start_date = dt;
      }
    } else {
      week_counter++;
      day_counter = 0;
      week_title = currentMonthName.charAt(0).toUpperCase() + currentMonthName.slice(1) +
        " - Semana " +
        week_counter;
      if (dbg) console.log("[BC:609] ---- End week: ", week_counter);
      calendar.push(
        {
          wkn: week_counter,
          wkt: week_title,
          wky: year,
          wkc: week,
          sd: start_date,
          ed: dt,
          wkds: week_data
        }
      );
      week_data = [];
    }
  }

  bdo_data = {
    sd: startMonthWeekDate.format("YYYY-MM-DD"),
    ed: endWeekDate.format("YYYY-MM-DD"),
    nwks: calendar.length,
    data: calendar,
    rdata: calendar_data
  };

  return bdo_data;
}

function getBitacoraData(
  checklist_id,
  end_date,
  d_type = "D", // D , S , M
  tipo_cliente = 1, //1=handheld, 2=tablet, 3=web
  d_subtract = 7, //Diario= 7/14 days, Semanal= 2/4 weeks, Mensual= 3/6 months
  bitacora_respuestas = {},
  lang = "es",
  modulo = null
) {
  let days_array = [];
  let first_day = null;
  let last_day = null;
  let meses_array = [];
  let semanas_array = [];
  let dbg = false;

  if (dbg) console.log("[GBD:653] Start getBitacoraData... ", d_type, end_date);

  switch (d_type) {
    case "D":
      //new bdo daily calendar
      bdo_daily_calendar = buildCalendar(checklist_id,
        end_date,
        d_subtract,
        bitacora_respuestas);

      first_day = bdo_daily_calendar.sd;
      last_day = bdo_daily_calendar.ed;
      days_array = bdo_daily_calendar.data;

      break;
    default:
      [
        first_day,
        last_day,
        days_array,
        semanas_array,
        meses_array
      ] = getReportData(
        checklist_id,
        end_date,
        d_type,
        tipo_cliente,
        d_subtract,
        bitacora_respuestas,
        lang,
        modulo
      );
      break;
  }
  if (dbg) {
    switch (d_type) {
      case "D":
        console.log("[GBD:690] dias array= ", days_array);
        break;
      case "S":
        console.log("[GBD:693] semanas array= ", semanas_array);
        break;
      case "M":
        console.log("[GBD:696] meses array= ", meses_array);
        break;
      default: break;
    }
  }
  if (dbg) console.log("[GBD:701] End getBitacoraData.");
  return [
    first_day,
    last_day,
    days_array,
    semanas_array,
    meses_array
  ];
}

function getElement(elem_array, search, value, data = null) {
  var length = elem_array.length;
  for (var i = 0; i < length; i++) {
    if (elem_array[i][search] == value) {
      if (data) {
        return elem_array[i][data];
      }
      return elem_array[i];
    }
  }
}

// exports the variables and functions above so that other modules can use them
module.exports.BdoWeekday = BdoWeekday;
module.exports.getBDOCurrentDate = getBDOCurrentDate;
module.exports.getBDOCurrentTimestamp = getBDOCurrentTimestamp;
module.exports.getBDOFirstDayOfWeek = getBDOFirstDayOfWeek;
module.exports.firstOfTheWeek = firstOfTheWeek;
module.exports.lastOfWeek = lastOfWeek
module.exports.getBDOLastDayOfWeek = getBDOLastDayOfWeek;
module.exports.getBDOWeekDaysArray = getBDOWeekDaysArray;
module.exports.getBDOUTCCurrentTimestamp = getBDOUTCCurrentTimestamp;
module.exports.getBDOUTCCurrentDate = getBDOUTCCurrentDate;
module.exports.getBDOFormattedDate = getBDOFormattedDate;
module.exports.getBDOFormat = getBDOFormat;
module.exports.isLeapYear = isLeapYear;
module.exports.isWeekGreatherThanCurrent = isWeekGreatherThanCurrent;
module.exports.isMonthGreatherThanCurrent = isMonthGreatherThanCurrent;
module.exports.formatWeekStartEndDays = formatWeekStartEndDays;
module.exports.formatMonthStartEndDays = formatMonthStartEndDays;
module.exports.isDateGreatherThanCurrent = isDateGreatherThanCurrent;
module.exports.isDateLessThanCurrent = isDateLessThanCurrent;
module.exports.getNextDate = getNextDate;
module.exports.getPrevDate = getPrevDate;
module.exports.getWeekAndYearFromDate = getWeekAndYearFromDate;
module.exports.getReportData = getReportData;
module.exports.getBitacoraData = getBitacoraData;
module.exports.getElement = getElement;
module.exports.buildMonthlyCalendarData = buildMonthlyCalendarData;
module.exports.getEndOfMonth = getEndOfMonth;
module.exports.getSimpleFormat = getSimpleFormat;
module.exports.getBDOWeeksRangesForDevice = getBDOWeeksRangesForDevice;
//References:
//Mexico official timezones
//https://www.cenam.mx/hora_oficial/default.aspx

//https://stackoverflow.com/questions/5210376/how-to-get-first-and-last-day-of-the-week-in-javascript
//https://stackabuse.com/how-to-use-module-exports-in-node-js/
//https://medium.freecodecamp.org/node-js-module-exports-vs-exports-ec7e254d63ac

//Azure Reference:
//https://docs.microsoft.com/en-us/azure/mysql/howto-server-parameters#working-with-the-time-zone-parameter

//Moment reference:
//https://momentjs.com/timezone/docs/
//https://www.npmjs.com/package/moment-timezone

//package to get timezone id from coordinates, Google API required
//https://www.npmjs.com/package/timezoner
//https://developers.google.com/maps/documentation/timezone/intro
//
//Get timezone id from IANA timezone database
//https://www.npmjs.com/package/geo-tz
//https://www.iana.org/time-zones
