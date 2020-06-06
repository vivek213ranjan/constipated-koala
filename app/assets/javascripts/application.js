// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery/dist/jquery.min
//= require jquery-ujs/src/rails
//= require bootstrap-file-input
//
//= require toastr
//
//= require dropdown
//= require editor
//= require mail
//
//= require clipboard/dist/clipboard.min
//= require turbolinks/dist/turbolinks
//= require bootstrap/dist/js/bootstrap.bundle.min.js
//= require toastr/build/toastr.min
//= require quill/dist/quill.min
//
//= require_tree ./admin
//
//= require language.js

$(document).on('ready page:load turbolinks:load', function () {
  $('.alert button.close').on('click', function () {
    $(this).closest('.alert').remove();
  });
});
