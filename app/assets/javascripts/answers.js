function ready() {
    $('.edit-answer-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $('form#edit_answer_' + $this.data('answer')).show();
        $this.hide();
    });
}

$(document).on('page:load', ready);
$(document).on('page:update', ready);
$(document).on('turbolinks:load', ready);