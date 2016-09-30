//= require jquery
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require cloudinary/jquery.cloudinary
//= require gigantic/attachinary

ready = function() {
  $('.attachinary-input').attachinary({labels: {
    files: 'Chemin du fichier', status: "Statut de l'image"
  }});
};

$(document).ready(ready);
$(document).on('page:load', ready);
