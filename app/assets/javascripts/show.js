  $(document).ready(function() {
   $('#overtime-modal').on('show.bs.modal', function (event) {
	
    var button = $(event.relatedTarget);
	var date = button.data('date');
	var week = button.data('week');
	var modal = $(this);
	modal.find('#modal-date').text(date);
	modal.find('#modal-week').text(week);
	})
  });