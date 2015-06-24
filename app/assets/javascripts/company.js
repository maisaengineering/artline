$(document).ready(function(){
    $("#add-more").click(function(e){
        e.preventDefault();
        $source_element = $("#field").closest('.row').clone(true)[0];
        $('#add-more').closest('.row').after($source_element)
        $($source_element).find('button').remove();
        $($source_element).find('.attention').val('');
    });
});
