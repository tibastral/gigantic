//= require jquery
//= require jquery.ui.widget
//= require jquery.iframe-transport
//= require jquery.fileupload
//= require cloudinary/jquery.cloudinary
//= require gigantic/attachinary

ready = function() {
  $('.attachinary-input').attachinary({labels: {
      files: 'Fichier', status: "Statut de l'image"
    },
    batchSize: 100
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
