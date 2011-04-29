;jQuery(function($) {
  var selector_prefix = 'body.controller-e9-polls-polls', 
      $selector       = $(selector_prefix);

  /**
   * Adds a new nested assocation.  Depends on the nested association
   * js templates being loaded.
   */
  $('a.add-nested-association').click(function(e) {
    e.preventDefault();

    var $this   = $(this), 
        $parent = $this.closest('.nested-associations'),
        obj,
        template,
        index;

    try { 
      obj = TEMPLATES[this.getAttribute('data-association')];
    } catch(e) { return }

    template = obj.template.replace(new RegExp(obj.index++, 'g'), obj.index);

    $(template).appendTo($parent);
  });

  /**
   * Effectively destroys an added nested association, removing the container
   * the association is not persisted, or hiding it and setting the _destroy
   * parameter for the association if it is.
   */
  $('a.destroy-nested-association').live('click', function(e) {
    e.preventDefault();

    var $parent = $(this).closest('.nested-association').hide(),
        $destro = $parent.find('input[id$=__destroy]');

    if ($destro.length) {
      $destro.val('1');
    } else {
      $parent.remove();
    }
  });
});
