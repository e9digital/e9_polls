;jQuery(function($) {
  $('body.admin table.records a.view-poll-results').colorbox({
    transition: 'none',
    width: '35%',
    height: '50%',
    onComplete: function() {
      $('#cboxLoadedContent div.poll-question')
        .replaceWith(function(i, content) {
          return "<h1>" + content + "</h1>";
        });
    }
  });

  $('.renderable.poll form').live('submit', function(e) {
    e.preventDefault();
    var el = $(this);

    // return if no selection
    if (!$("input[@name='poll[vote]']:checked").val()) return;

    $.ajax({
      url: el.attr('action'),
      data: el.serializeArray(),
      dataType: 'json',
      type: 'POST',
      success: function(data, status, xhr) {
        el.closest('.renderable.poll').html(data.html);
      }
    });
  });

  $('.poll .view-poll-results, .poll .view-poll-form').live('click', function(e) {
    e.preventDefault();
    var el = $(this);

    $.ajax({
      url: el.attr('href'),
      dataType: 'json',
      type: 'GET',
      success: function(data, status, xhr) {
        el.closest('.renderable.poll').html(data.html);
      }
    });
  });

  /*
   * add poll class handler to quick_edit.
   *
   * TODO Come up with a nicer method of setting defaults
   *
   * NOTE It's probably overkill and unnecessary to worry about load order, 
   *      which is the complicating factor here.
   */
  $.quick_edit = $.quick_edit || {};
  $.quick_edit.class_handlers = $.extend({
    'poll' : function(el) {
      var path   = el.attr('data-renderable-path'), 
          npath  = el.attr('data-update-node-path'),
          //rpath  = path + '/replace?node_id=' + el.attr('data-node'),
          epath  = path + '/edit';

      return '<a class="qe-qelink" href="'+ epath +'">Edit</a>' +
             '<a class="qe-ulink"  href="'+ npath +'">Switch</a>' +
             '<a class="qe-elink"  href="'+ epath +'">Admin</a>';
    }
  }, $.quick_edit.class_handlers);


  var selector_prefix = 'body.controller-e9-polls-polls', 
      $selector       = $(selector_prefix);

  /**
   * Adds a new nested assocation.  Depends on the nested association
   * js templates being loaded.
   */
  $('a.add-nested-association').live('click', function(e) {
    e.preventDefault();

    var $this   = $(this), 
        $fields = $this.closest('.nested-associations').find('.fields'),
        obj,
        template,
        index;

    try { 
      obj = TEMPLATES[this.getAttribute('data-association')];
    } catch(e) { return }

    template = obj.template.replace(new RegExp(obj.index++, 'g'), obj.index);

    $(template).appendTo($fields);

    try { $.colorbox.resize() } catch(e) {}
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

    try { $.colorbox.resize() } catch(e) {}
  });
});
