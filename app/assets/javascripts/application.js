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
  // $("#responsable").on("change" , alertIfEmpty); OLD ONE
  $("#responsable").on("input propertychange paste" , alertIfEmpty);
  $("#tag").on("input propertychange paste" , alertIfEmpty);
  $("#number-field").on("input propertychange paste" , alertIfEmpty);

  // $(".see-sample").on("click" , showDamageSample);

});

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
    $(this).css("background-color", "#FCB3BC");
    // $(this).css("border", "red");
  } else{
    $(this).css("background-color", "#FFFFFF");
    // $(this).css("border", "red");
  }
}


function showDamageSample(){
  var id = $(this).attr('id_number')
  event.preventDefault()
  console.log(id);
  // Implementar ajax call
  swal({
  title: '<i>HTML</i> <u>example</u>',
  type: 'info',
  html:
    'You can use <b>bold text</b>, ' +
    '<a href="//github.com">links</a> ' +
    'and other HTML tags',
  showCloseButton: true,
  showCancelButton: true,
  confirmButtonText:
    '<i class="fa fa-thumbs-up"></i> Great!',
  cancelButtonText:
    '<i class="fa fa-thumbs-down"></i>'
})
}
