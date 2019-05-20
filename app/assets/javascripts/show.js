
  jQuery(document).ready(function() {
   jQuery('#overtime-modal').on('show.bs.modal', function (event) {
	
    var button = jQuery(event.relatedTarget);
	var date = button.data('date');
	var week = button.data('week');
    var hidden_date = button.data('hidden_date')
	var modal = jQuery(this);
	modal.find('#modal-date').text(date);
	modal.find('#modal-week').text(week);
	modal.find('#modal-hidden_date').val(hidden_date);
	})
  });