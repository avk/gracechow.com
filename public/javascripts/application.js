// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function lightboxLoading(hidePrevious) {
  // console.log("loading the lightbox...");
  if (hidePrevious) {
    resetLightboxContent();
  }
  $('lightbox_wrapper').style.display='block';
  $('lightbox_content').style.left='48%';
  $('lightbox_content').style.top='48%';
}

// from Craig Ambrose's Redbox plugin
function resizeLightbox() {
  // console.log("resizing the lightbox...");
  var pagesize = this.getPageSize();  

  $("lightbox_content").style['width'] = 'auto';
  $("lightbox_content").style['height'] = 'auto';

  var dimensions = Element.getDimensions($("lightbox_content"));
  var width = dimensions.width;
  var height = dimensions.height;

  $("lightbox_content").style['left'] = ((pagesize[0] - width)/2) + "px";
  // $("lightbox_content").style['top'] = ((pagesize[1] - height)/2) + "px";

  // $("lightbox_content").style['left'] = '50px';
  $("lightbox_content").style['top'] = '50px';
}

// from Craig Ambrose's Redbox plugin
function getPageSize() {
  var de = document.documentElement;
  var w = window.innerWidth || self.innerWidth || (de&&de.clientWidth) || document.body.clientWidth;
  var h = window.innerHeight || self.innerHeight || (de&&de.clientHeight) || document.body.clientHeight;

  arrayPageSize = new Array(w,h);
  return arrayPageSize;
}

function closeLightbox() {
  // console.log("closing the lightbox...");
  $('lightbox_wrapper').style.display='none';
  resetLightboxContent();
}

function resetLightboxContent() {
  // console.log("resetting the lightbox...");
  $('lightbox_content').innerHTML = "<img src='/images/loading.gif' /><br /><a href='#' onclick='closeLightbox()'>Cancel</a>";
}

Event.observe(window, 'load', function(){ resetLightboxContent(); });