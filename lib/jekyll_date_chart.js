$(document).ready(function() {
  
  $('.dchart').each(function() {

    new Morris.Line({
      // ID of the element in which to draw the chart.
      element: $(this).attr('id'),
      
      // Chart data records -- each entry in this array corresponds to a point on the chart.
      // Example: [{ date: '2006', a: 100, b: 90 }]
      // setData() to update - see example at https://github.com/oesmith/morris.js/blob/master/examples/updating.html
      data: $(this).data('entries'),
      
      // The name of the data record attribute that contains x-values.
      xkey: 'date',
      
      // Sets the x axis labelling interval. By default the interval will be automatically computed.
      // See http://www.oesmith.co.uk/morris.js/lines.html for valid interval strings.
      //xLabels: 'month',
      
      // A list of names of data record attributes that contain y-values.
      ykeys: $(this).data('ykeys'),
      
      // Labels for the ykeys -- will be displayed when you hover over the chart.
      labels: $(this).data('ykeys'),
      
      preUnits:  $(this).data('unit') + ' ',
      // postUnits: $(this).data('unit') + ' ',
      
      goals: ['0.0'],
      goalStrokeWidth: '5',
      goalLineColors: ['#000000'],
      
      smooth: false
    });
  
  });
  
});


// new Morris.Line({element: 'dchart', data: lines, xkey: 'date', ykeys: ['value'], labels: ['Value']});
