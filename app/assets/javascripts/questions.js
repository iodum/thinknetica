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

    $('.edit-comment-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $this.parents('.comments-wrapper').find('form').show();
        $this.hide();
    });

    $('.vote-link').on('ajax:success',function(e, data){

        e.preventDefault();
        var $this = $(this),
            $wrap = $this.parent('.rating-wrapper');
        $wrap.find('.vote-link').removeClass('btn-success');
        if (data.value != 0) {
            $this.addClass('btn-success');
        }
        $wrap.find('.rating-result').html(data.rating);


    }).on('ajax:error', function(e, xhr) {
        console.log(xhr.responseJSON);
    });

}

$( document ).ready( ready );
$( document ).on('ajax:success', ready );
