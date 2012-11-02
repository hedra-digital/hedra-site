bkLib.onDomLoaded(function() {
  var myNicEditor = new nicEditor({
    buttonList : ['bold','italic','underline','left','center','right','justify','ol','ul','indent','outdent','link','unlink','subscript','superscript','xhtml','removeformat'],
    iconsPath : '/assets/editoricons.gif'
  });
  myNicEditor.panelInstance('nicedit-1');
});
