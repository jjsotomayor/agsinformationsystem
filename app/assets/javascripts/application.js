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

// NOTE: Cada vez que se agregue una validacion, se debe argegar en 2 lugares
// NOTE Todo se esta validando como cualquier numero(sea entero o decimal)
$(document).on('turbolinks:load', function(){

  $(".validatable #tag").on("input propertychange paste", {non_blank: true, number: false }, validation_event_handler);

  //////////////////////////////
  //Elements form validations //
  //////////////////////////////
  $(".validatable #element_tag").on("input propertychange paste", {non_blank: true, number: false }, validation_event_handler);
  $(".validatable #element_product_type_id").on("input propertychange paste", {non_blank: true, number: false }, validation_event_handler);
  // TODO validate kgs
  // $(".validatable #element_weight").on("input propertychange paste", {non_blank: true, number: "integer" }, validation_event_handler);

  //////////////////////////////
  ////HUMIDITY samples //////////
  //////////////////////////////
  // $(".validatable #humidity_sample_humidity").bind("keyup" , changeCommaToPoint);
  $(".validatable #humidity_sample_humidity").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);

  //////////////////////////////
  ////Sorbate samples //////////
  //////////////////////////////
  // $(".validatable #sorbate_sample_sorbate").bind("keyup" , changeCommaToPoint);
  $(".validatable #sorbate_sample_sorbate").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);

  //////////////////////////////
  ////Caliber samples //////////
  //////////////////////////////
  // $(".validatable #caliber_sample_sample_weight").bind("keyup" , changeCommaToPoint);
  $(".validatable #caliber_sample_sample_weight").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);

  // $(".validatable #caliber_sample_fruits_in_sample").bind("keyup" , changeCommaToPoint);
  $(".validatable #caliber_sample_fruits_in_sample").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);

  // $(".validatable #big_fruits_in_sample").bind("keyup" , changeCommaToPoint);
  $(".validatable #big_fruits_in_sample").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);

  // $(".validatable #small_fruits_in_sample").bind("keyup" , changeCommaToPoint);
  $(".validatable #small_fruits_in_sample").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);
  $(".validatable #caliber_sample_is_ex_caliber").on("input propertychange paste", {non_blank: true, number: false}, validation_event_handler);

  //////////////////////////////
  //// Damage Samples //////////
  //////////////////////////////
  // $(".validatable #process_order").on("input propertychange paste", {non_blank: true, number: false}, validation_event_handler);
  $(".validatable #lot").on("input propertychange paste", {non_blank: true, number: false}, validation_event_handler);

  $(".validatable #drying_method_id").on("input propertychange paste", {non_blank: true, number: false}, validation_event_handler);

  // $(".validatable #damage_sample_sample_weight").bind("keyup" , changeCommaToPoint);
  $(".validatable #damage_sample_sample_weight").on("input propertychange paste", {non_blank: true, number: "integer"}, validation_event_handler);

  // Damages //
  // No hay necesidad para validar esto ya que te exige numero
  // $(".validatable #damage_sample_off_color").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_off_color").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_poor_texture").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_poor_texture").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_scars").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_scars").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_end_cracks").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_end_cracks").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_skin_or_flesh_damage").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_skin_or_flesh_damage").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_fermentation").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_fermentation").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_heat_damage").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_heat_damage").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_insect_injury").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_insect_injury").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_mold").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_mold").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_dirt").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_dirt").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_foreign_material").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_foreign_material").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_vegetal_foreign_material").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_vegetal_foreign_material").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_insect_infestation").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_insect_infestation").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_decay").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_decay").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);
  //
  // $(".validatable #damage_sample_carozo").bind("keyup" , changeCommaToPoint);
  // $(".validatable #damage_sample_carozo").on("input propertychange paste", {non_blank: false, number: "integer"}, validation_event_handler);




  // TODO solo detener el submit si hay errores
  // $("form#new_humidity_sample").submit(function(e){
// form
// $(".validatable").submit(function(e){
  $("form.validatable").submit(function(e){
      if (run_all_validations(e)){
        e.preventDefault();
        swal('No almacenada!','Arregla las celdas en rojo e intenta nuevamente', 'error') //success warning error
        $(".btn[type=submit]").removeAttr("data-disable-with") //NOTE El selector del boton "guardar" es muy general
      }
    });


});



// Estas son las validaciones que se corren al cliguear guardar!
function run_all_validations(e){
    console.log("Running validations");
    // function validate($elem, non_blank, number_format){
    var error = false;
    if (!validate($(".validatable #tag"),                             true, false)){ error = true;}
    // Elements form //
    if (!validate($(".validatable #element_tag"),                     true, false)){ error = true;}
    if (!validate($(".validatable #element_product_type_id"),         true, false)){ error = true;}
    // TODO validar kgs
    // if (!validate($(".validatable #element_weight"),                  true, "integer")){ error = true;}
    //// HUumidity samples //////////
    if (!validate($(".validatable #humidity_sample_humidity"),        true, "integer")){ error = true;}
    ////Sorbate samples //////////
    if (!validate($(".validatable #sorbate_sample_sorbate"),          true, "integer")){ error = true;}
    ////Caliber samples //////////
    if (!validate($(".validatable #caliber_sample_sample_weight"),    true, "integer")){ error = true;}
    if (!validate($(".validatable #caliber_sample_fruits_in_sample"), true, "integer")){ error = true;}
    if (!validate($(".validatable #big_fruits_in_sample"),            true, "integer")){ error = true;}
    if (!validate($(".validatable #small_fruits_in_sample"),          true, "integer")){ error = true;}
    if (!validate($(".validatable #caliber_sample_is_ex_caliber"),    true, false)){ error = true;}
    //// Damage Samples //////////
    // if (!validate($(".validatable #process_order"),                   true, false)){ error = true;}
    if (!validate($(".validatable #lot"),                   true, false)){ error = true;}
    if (!validate($(".validatable #drying_method_id"),                true, false)){ error = true;}
    if (!validate($(".validatable #damage_sample_sample_weight"),     true, "integer")){ error = true;}

    return error;
}


function validation_event_handler(event){
  // console.log("Validando");
  var non_blank = event.data.non_blank;
  var number_format =  event.data.number;
  validate($(this), non_blank, number_format)
}


// Permite parametros non_blank: boolean, number: ("integer", "decimal" o false)
// TODO: actualmente no distingue integer de decimal(solo valida que sea numero)
function validate($elem, non_blank, number_format){
  if (!$elem.length){ //Chequea si $elem es un elemento o esta vacio
    return true;
  }

  var type_number = false;
  if (typeof number_format === "string"){
    type_number = true;
  }

  var text = $elem.val();
  //NOTE Reemplazamos antes comas por puntos (permite no marcar como erroneo apenas
  // se escribe una "," porque se valida antes de autocambiarlo a ".")
  text = text.replace(/\,/g, '.');

  var error = false;

  if (non_blank & !text.trim().length){ //Check if empty
    console.log('Blanco!');
    error = true;
  }
  //Check if number
  if (type_number & isNaN(text)){
    console.log('No es NUMERO!');
    error = true;
  }

  if (error){
    $elem.addClass( "field-with-errors");
    return false;
  } else{
    $elem.removeClass( "field-with-errors" );
    return true;
  }
}






function changeCommaToPoint(event){ //Cuando se tipea una comma, se reemplaza por un punto
      console.log("Checking commas");
      var old_value = $(this).val()
      // old != "" es necesario porque si field tiene numero invalido en number-fields, el .val() leerá ""
      if (event.which == 188 & old_value != "") { // ,(188) .(190)
        // console.log("Old value");
        // console.log(old_value);
        var new_value = old_value.replace(/\,/g, '.');
        // console.log("new value");
        // console.log(new_value);
        if (old_value != new_value){ // Soluciona problema cuando se ingresa "936." en number-field.
          $(this).val(new_value);
        }
      }
}
