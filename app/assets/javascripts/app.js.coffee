$ ->
  $('#select-genre').selectize({
    plugins: ['remove_button'],
    maxItems: null,
    valueField: 'id',
    labelField: 'title',
    searchField: 'title',
  })

  new ZeroClipboard( document.getElementById("copy") )
