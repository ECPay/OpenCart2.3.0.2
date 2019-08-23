<div class="table-responsive">
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th colspan="2" class="text-center"><?php echo $text_title; ?></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td class="text-right" style="width:25%;"><strong><?php echo $entry_payment_method; ?></strong></td>
                <td class="text-left" style="width:75%;">
                    <select name="<?php echo $name_prefix; ?>_choose_payment" id="<?php echo $id_prefix; ?>-choose-payment" class="form-control">
                        <option value="">請選擇</option>
                        <?php foreach ($ecpaypayment_payment_methods as $key => $value) { ?>
                        <option value="<?php echo $key; ?>"><?php echo $value; ?></option>
                        <?php } ?>
                    </select>
                </td>
            </tr>
        </tbody>
        <tfoot>
        </tfoot>
    </table>
</div>

<?php if ($ecpay_invoce_status == 1) { ?>
<div class="table-responsive">
    <table class="table table-bordered table-hover">
        <thead>
            <tr>
                <th colspan="2" class="text-center"><?php echo $ecpay_invoce_text_title; ?></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td class="text-right" style="width:25%;"><strong>發票開立</strong></td>
                <td class="text-left" style="width:75%;">
                    <input type="radio" name="invoice_type" id="invoice_type_1" value="1"> 個人發票&nbsp;&nbsp;
                    <input type="radio" name="invoice_type" id="invoice_type_2" value="2"> 公司戶發票&nbsp;&nbsp;
                    <input type="radio" name="invoice_type" id="invoice_type_3" value="3"> 捐贈
                </td>
            </tr>

            <tr class="invoice_info"  style="display:none;" >
                <td class="text-right" style="width:25%;"><strong>統一編號</strong></td>
                <td class="text-left" style="width:75%;"><input type="text" name="company_write" id="company_write" value="" placeholder="統一編號" class="form-control"></td>
            </tr>
             <tr class="donation_info"  style="display:none;" >
                <td class="text-right" style="width:25%;"><strong>愛心碼</strong></td>
                <td class="text-left" style="width:75%;"><input type="text" name="love_code" id="love_code" value="" placeholder="請輸入愛心碼3-7位數" class="form-control"><a href = "https://www.einvoice.nat.gov.tw/APMEMBERVAN/XcaOrgPreserveCodeQuery/XcaOrgPreserveCodeQuery" target="_blank">愛心碼查詢</a></td>
            </tr>
        </tbody>
        <tfoot>
        </tfoot>
    </table>
</div>
<?php } ?>

<div class="buttons">
    <div class="pull-right">
        <input type="button" value="<?php echo $text_checkout_button ?>" id="<?php echo $id_prefix; ?>-checkout-button" class="btn btn-primary" onclick="checkout()"/>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function() {
        $("#payment-ecpaypayment-choose-payment").change(function() {
            var postUrlParent = 'index.php?route=extension/payment/<?php echo $module_name; ?>/';
            var postUrl = '';
            var postData = '';
            
            // save chosen payment
            var chosenPayment = $("#<?php echo $id_prefix; ?>-choose-payment").find(":selected").val();
            postUrl = postUrlParent + 'savePayment';
            postData = 'cp=' + chosenPayment;
            var response = simpleAjax(postData, postUrl);
        });


        // $('input[type=radio][name=payment_method]').change(function() {
            
        //     var postUrlParent = 'index.php?route=extension/payment/<?php echo $module_name; ?>/';
        //     var postUrl = '';
        //     var postData = '';

        //     if (this.value != 'ecpaypayment') {
        //         postUrl = postUrlParent + 'cleanSession';
        //         var response = simpleAjax(postData, postUrl);
        //     } 
        // });

    });

    // Simple Ajax
    function simpleAjax(postData, postUrl) {
        var parsed = false;
        var async = false;
        jQuery.ajax({
            type: 'post',
            async : async,
            url: postUrl,
            data: postData,
            success: function (response) {
                parsed = JSON.parse(response);
                console.log(response)
            },
            error: function(errorObject, errorText, errorHTTP) {
                // console.log('error: ' . errorText);
            }
        });
        return parsed;
    }
</script>

<script type="text/javascript">
    // 個人發票
    $( "#invoice_type_1" ).on( "click", function() {
        remove_invoice_info();
        $(".invoice_info").slideUp(0);
        $(".donation_info").slideUp(0);
        
        $("#company_write").val("");
        $("#love_code").val("");

        save_invoice_info();
    });

    // 公司發票
    $( "#invoice_type_2" ).on( "click", function() {
        remove_invoice_info();
        $(".invoice_info").slideDown(0);
        $(".donation_info").slideUp(0);
        
        $("#love_code").val("");
    });

    // 捐贈
    $( "#invoice_type_3" ).on( "click", function() {
        remove_invoice_info();
        $(".invoice_info").slideUp(0);
        $(".donation_info").slideDown(0);

        $("#company_write").val("");
    });

    // 記錄發票資訊
    $( "#company_write, #love_code" ).on( "change", function () {
        var result = validate_invoice_info();
        if (result === "") {
            save_invoice_info();
        }
    });

    function save_invoice_info() {
        //記錄發票資訊
        var invoice_type = $('input:radio[name="invoice_type"]:checked').val();
        var company_write   = $("#company_write").val()
        var love_code       = $("#love_code").val()

        var postUrl = ''
        var postUrlParent = 'index.php?route=extension/payment/<?php echo $module_name; ?>/';
        postUrl = postUrlParent + 'saveInvoice';

        var send = {company_write:company_write, love_code:love_code,invoice_type:invoice_type,invoice_status:'1'};

        $.ajax({
            type: 'POST',
            url: postUrl,
            data: send,
            dataType: "json",
            success: function (sMsg){
                console.log(sMsg);
            },
            error: function (sMsg1, sMsg2){
                // alert("失敗");
            }
        });
    }

    function remove_invoice_info() {
        
        var postUrl = ''
        var postUrlParent = 'index.php?route=extension/payment/<?php echo $module_name; ?>/';
        postUrl = postUrlParent + 'delInvoice';
        
        var send = {invoice_status:'1'};

        //清除發票資訊
        $.ajax({
            type: 'POST',
            url: postUrl,
            data: send,
            dataType: "json",
            success: function (sMsg){
                console.log(sMsg);
            },
            error: function (sMsg1, sMsg2){
                // alert("失敗");
            }
        });
    }

    function validate_invoice_info() {

        //驗證發票資訊
        var invoice_type = $('input:radio[name="invoice_type"]:checked').val();
        if(invoice_type == null)
        {
            return "請選擇發票開立類型";
        }
        else
        {
            // 統一編號檢查
            if (invoice_type == 2)
            {
                var company_write = $('input:text[name="company_write"]').val();
                if (company_write === '')
                {
                    return "請填寫統一編號";
                }

                var result = company_write.match(/^\d{8}$/);
                if(result == null)
                {
                    return "統一編號格式錯誤";
                }
            }

            // 愛心碼檢查
            if (invoice_type == 3)
            {
                var love_code = $('input:text[name="love_code"]').val();
                if (love_code === '')
                {
                    return "請填寫愛心碼";
                }

                var result = love_code.match(/^([xX]{1}[0-9]{2,6}|[0-9]{3,7})$/);
                if(result == null)
                {
                    return "愛心碼格式錯誤";
                }
            }
        }
        return "";
    }
</script>

<script type="text/javascript">
    
    function checkout()
    {
        // 檢查付款方式
        var ecpayPaymentRadio = $("#<?php echo $id_prefix; ?>-choose-payment").val();
        if(ecpayPaymentRadio == '')
        {
          alert("請選擇付款方式");  
          return false ;
        }
        else
        {
            // 判斷電子發票是否輸入
            <?php if ($ecpay_invoce_status == 1) { ?>
                var result = validate_invoice_info();
                if (result !== "") {
                    alert(result);
                    return false;
                }

            <?php } ?>

            location.href='<?php echo $redirect_url; ?>';  
        }
    }
    
</script>