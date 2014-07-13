CKEDITOR.editorConfig = function( config )
  {
    config.toolbar_Basic =
    [
        { name: 'document',    items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat','Source' ] },
        { name: 'clipboard',   items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
        { name: 'paragraph',   items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote' ] },
        { name: 'links',       items : [ 'Link','Unlink','Anchor' ] },
        { name: 'insert',      items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar' ] },
    ];
    config.toolbar = 'Basic';

    config.allowedContent = 'iframe[*]';
  };
