function ready() {
    $('.edit-question-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $('form#edit_question_' + $this.data('question')).show();
        $this.hide();
    });
}

$(document).on("turbolinks:load", ready)