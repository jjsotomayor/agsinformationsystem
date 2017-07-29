// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks

//Agregado para que funcione bootstrap
//= require bootstrap-sprockets
//Agregado para que funcione css Vendor files
// = require sweetalert.min.js

///

//= require_tree .



$(document).on('turbolinks:load', function(){

  // $("#tag").on("input propertychange paste" , alertIfEmpty);
  $("#tag").on("input propertychange paste" , alertIfNotNumber);
  // $("#caliber_sample_sample_weight").on("input propertychange paste" , alertIfEmpty);
  $("#caliber_sample_sample_weight").on("input propertychange paste" , alertIfNotNumber);
  $("form #tag").bind("keyup" , changeCommaToPoint);



// if (isNaN(x))

  // $(".not-blank").on("input propertychange paste" , alertIfEmpty);
  // $(".number").on("input propertychange paste" , alertIfNotNumber);
  // $(".decimal-number").on("input propertychange paste" , alertIfNotNumber);


  // $("#number-field").on("input propertychange paste" , alertIfEmpty);
  // $(".see-sample").on("click" , showDamageSample);




});

//Cuando se tipea una comma, se reemplaza por un punto
function changeCommaToPoint(event){
      // console.log(event.which);
      if (event.which == 188) { // ,(188) .(190)
        var old = $(this).val()
        var new_value = old.replace(/\,/g, '.');
        $(this).val(new_value);
      }
}





function changeTotalPriceBudgetaryItem(){
  console.log('entré al método');
  var tmp = chooseCurrencyValue();
  console.log(tmp+'temporal en la wea de metodo');
  console.log(typeof(tmp));
  var quantity = $("#quantity").val();
  var price = $("#unit_price").val();
  $("#total_price").val(Math.round(quantity*price*tmp));
}
//Math.round(quantity*price*tmp)

function chooseCurrencyValue(){
  var currency=0;
  if(dailyIndicators != null){
    var combocurrency = $('#currency').val();
    if(combocurrency ==='CLP'){
      currency =1;
    }else if (combocurrency=== 'UF') {
      currency = dailyIndicators.uf.valor;
    }else if (combocurrency=== 'USD') {
      currency = dailyIndicators.dolar.valor;
    }else if (combocurrency=== 'UTM') {
      currency= dailyIndicators.utm.valor;
    }else if (combocurrency === 'EUR') {
      currency = dailyIndicators.euro.valor;
    }else {
      currency = 1;
    }
  }
  return currency;
}

function alertIfEmpty(){
  var text = $(this).val()
  if (!text.trim().length){
    $(this).addClass( "field-with-errors");
  } else{
    $(this).removeClass( "field-with-errors" );
  }
}

function alertIfNotNumber(){
  var text = $(this).val()
  if ( isNaN(text) ){
    $(this).addClass( "field-with-errors");
    // console.log('entré add');
  } else{
    $(this).removeClass( "field-with-errors" );
    // console.log('entré desadd');

  }
}
