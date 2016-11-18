function ready() {
    $('.edit-question-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $('form#edit_question_' + $this.data('question')).show();
        $this.hide();
    });

    $('.edit-answer-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $('form#edit_answer_' + $this.data('answer')).show();
        $this.hide();
    });

    $('.vote-link').on('ajax:success',function(e, data){
        e.preventDefault();
        var $this = $(this);
        $('.vote-link').removeClass('btn-success');
        if (data.value != 0) {
            $this.addClass('btn-success');
        }
        $this.parent('.rating-wrapper').find('.rating-result').html(data.rating);


    }).on('ajax:error', function(e, xhr) {
        console.log(xhr.responseJSON);
    });


}

$( document ).ready( ready );
$( document ).on('ajax:success', ready );
