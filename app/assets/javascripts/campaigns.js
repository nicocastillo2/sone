$(function() {
  $(document).on('click', '#contacts-feedback a', function(event) {
    event.preventDefault();
    var dataType = $('#contacts-feedback').attr('data-feedback-type');
    var link = $(this).attr('href');
    var dateNumber = $('.report-select').find(":selected").val();
    var sentData = { "filter[nps_date]" : dateNumber, 'feedback_type': dataType };
    var feedback_type = $('#contacts-feedback').attr('data-feedback-type');
    var params;

    if (feedback_type!==undefined) {
      params = $("#filter-form").serialize()+"&feedback_type="+dataType;
    } else {
      params = $("#filter-form").serialize();
    }

    $.post(link, params, function(data){
      $("#contacts-feedback").html(data);
    });
  });

  $(document).on('click', '#all-campaigns', function(event) {
    event.preventDefault();
    if ($('#campaigns-checkboxes input').is(':checked')) {
      $('#campaigns-checkboxes input').removeAttr('checked');
    } else {
      $('#campaigns-checkboxes input').prop('checked', true );
    }
  });

  $(document).on('click', '#all-topics', function(event) {
    event.preventDefault();
    if ($('#topics-checkboxes input').is(':checked')) {
      $('#topics-checkboxes input').removeAttr('checked');
    } else {
      $('#topics-checkboxes input').prop('checked', true );
    }
  });

  $(document).on('click', '.feedback-stat:not(:first-child) span', function(event) {
    event.preventDefault();
    // Collect data to send through AJAX post request
    var urlPathname = window.location.pathname;
    var reportUrl = $('#download-report').attr('href');
    var dataType = $(this).attr('data-feedback-type');
    var feedbackType = '&feedback_type=' + dataType;
    var modifiedUrl = reportUrl + feedbackType;
    $('#download-report').attr('href', modifiedUrl);

    var sendData = $("#filter-form").serialize() + '&feedback_type=' + dataType;

    $.post(urlPathname, sendData, function(data){
      $("#contacts-feedback").html(data);
      $('#contacts-feedback').attr('data-feedback-type', dataType);
    });

  });


  // preview create campaign
  $(document).on("keyup change focusout", "#nombre-empresa-field", function(){
    var nombre = $(this).val() + " a un amigo o familiar?";
    $("#nombre-empresa-preview").html(nombre);
  });

  $(document).on("click", "#img-logo-img",function() {
    $("#img-logo-field").click();
  });

  $(document).on("change", "#img-logo-field", function(event) {
    var reader = new FileReader();
    reader.onload = function(e) {
      $("#img-logo-preview").attr('src', e.target.result);
    };

    reader.readAsDataURL(event.target.files[0]);
    // var url = event.target.files[0];
    // $("#img-logo-preview").attr('src', url);
  });
  // end preview create campaign
});

 
 function tooltip_contents(d, defaultTitleFormat, defaultValueFormat, color) {
    var $$ = this, config = $$.config, CLASS = $$.CLASS,
        titleFormat = config.tooltip_format_title || defaultTitleFormat,
        nameFormat = config.tooltip_format_name || function (name) { return name; },
        valueFormat = config.tooltip_format_value || defaultValueFormat,
        text, i, title, value, name, bgcolor;
    
    // You can access all of data like this:
    console.log($$.data.targets);
    
    for (i = 0; i < d.length; i++) {
        if (! (d[i] && (d[i].value || d[i].value === 0))) { continue; }

        // ADD
        if (d[i].name === 'data2') { continue; }
        
        if (! text) {
            title = 'MY TOOLTIP'
            text = "<table class='" + CLASS.tooltip + "'>" + (title || title === 0 ? "<tr><th colspan='2'>" + title + "</th></tr>" : "");
        }

        name = nameFormat(d[i].name);
        value = valueFormat(d[i].value, d[i].ratio, d[i].id, d[i].index);
        bgcolor = $$.levelColor ? $$.levelColor(d[i].value) : color(d[i].id);

        text += "<tr class='" + CLASS.tooltipName + "-" + d[i].id + "'>";
        text += "<td class='name'><span style='background-color:" + bgcolor + "'></span>" + name + "</td>";
        text += "<td class='value'>" + value + "</td>";
        text += "</tr>";
    }
    return text + "</table>";   
}



// function(d, defaultTitleFormat, defaultValueFormat, color){
//   console.log(d);
//   var content = '<table class="c3-tooltip"><tbody>';
//   content += '<tr><th colspan="2">'+window.graphX[d[0].x]+'</th></tr>';

//   for(var i = 0;i<d.length;i++){
//     var currentColor = this.levelColor ? this.levelColor(d[i].value) : color(d[i].id)
//     content += '<tr class="c3-tooltip-name-'+d[i].name+'">';
//     content += '<td class="name"><span style="background-color:'+currentColor+'"></span>'+d[i].name+'</td>';
//     content += '<td class="value">'+d[i].value+'</td></tr>';
//     content += '</tbody></table>'
//   }
//   return content;
// }