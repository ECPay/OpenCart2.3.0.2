<?php echo $header; ?>
<?php echo $column_left; ?>
<div id="content">
    <div class="page-header">
        <div class="container-fluid">
            <div class="pull-right">
                <button type="submit" form="form-popular" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary">
                    <i class="fa fa-save"></i>
                </button>
                <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default">
                    <i class="fa fa-reply"></i>
                </a>
            </div>
            <ul class="breadcrumb">
                <?php foreach ($breadcrumbs as $breadcrumb) { ?>
                <li>
                    <a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
                </li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger">
        <i class="fa fa-exclamation-circle"></i>
        &nbsp;<?php echo $error_warning; ?>
        <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">
                    <i class="fa fa-pencil"></i>
                    &nbsp;<?php echo $heading_title; ?>
                </h3>
            </div>
            <div class="panel-body">
                <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" id="form-<?php echo $id_prefix; ?>" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-<?php echo $id_prefix; ?>-status">
                            <?php echo $entry_status; ?>
                        </label>
                        <div class="col-sm-8">
                            <select name="<?php echo $name_prefix; ?>_status" id="input-<?php echo $id_prefix; ?>-status" class="form-control">
                                <?php foreach ($module_statuses as $temp_status) { ?>
                                    <?php if ( $temp_status['value'] == $status ) { ?>
                                        <option value="<?php echo $temp_status['value']; ?>" selected="selected"><?php echo $temp_status['text']; ?></option>
                                    <?php } else { ?>
                                        <option value="<?php echo $temp_status['value']; ?>"><?php echo $temp_status['text']; ?></option>
                                    <?php } ?>
                                <?php } ?>
                            </select>
                        </div>

                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label"for="input-<?php echo $id_prefix; ?>-merchant-id">
                            <span data-toggle="tooltip" title="Merchant ID">
                                <?php echo $entry_merchant_id; ?>
                            </span>
                        </label>
                        <div class="col-sm-8">
                            <input type="text" name="<?php echo $name_prefix; ?>_merchant_id" value="<?php echo $merchant_id; ?>" placeholder="Merchant ID" id="input-<?php echo $id_prefix; ?>-merchant-id" class="form-control" />
                        </div>
                        <div class="text-danger"><?php echo $merchant_id_error; ?></div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="input-<?php echo $id_prefix; ?>-hash-key">
                            <span data-toggle="tooltip" title="Hash Key">
                                <?php echo $entry_hash_key; ?>
                            </span>
                        </label>
                        <div class="col-sm-8">
                            <input type="text" name="<?php echo $name_prefix; ?>_hash_key" value="<?php echo $hash_key; ?>" placeholder="Hash Key" id="input-<?php echo $id_prefix; ?>-hash-key" class="form-control" />
                        </div>
                        <div class="text-danger"><?php echo $hash_key_error; ?></div>
                    </div>
                    <div class="form-group required">
                        <label class="col-sm-2 control-label" for="input-<?php echo $id_prefix; ?>-hash-iv">
                            <span data-toggle="tooltip" title="Hash IV">
                                <?php echo $entry_hash_iv; ?>
                            </span>
                        </label>
                        <div class="col-sm-8">
                            <input type="text" name="<?php echo $name_prefix; ?>_hash_iv" value="<?php echo $hash_iv; ?>" placeholder="Hash IV" id="input-<?php echo $id_prefix; ?>-hash-iv" class="form-control" />
                        </div>
                        <div class="text-danger"><?php echo $hash_iv_error; ?></div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-<?php echo $id_prefix; ?>-methods">
                            <?php echo $entry_payment_methods; ?>
                        </label>
                        <div class="col-sm-8">
                            
                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[Credit]" value="credit" <?php if (isset($payment_methods['Credit'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_credit; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[Credit_3]" value="credit_3"<?php if (isset($payment_methods['Credit_3'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_credit_3; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[Credit_6]" value="credit_6"<?php if (isset($payment_methods['Credit_6'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_credit_6; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[Credit_12]" value="credit_12"<?php if (isset($payment_methods['Credit_12'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_credit_12; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[Credit_18]" value="credit_18"<?php if (isset($payment_methods['Credit_18'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_credit_18; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[Credit_24]" value="credit_24"<?php if (isset($payment_methods['Credit_24'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_credit_24; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[WebATM]" value="webatm"<?php if (isset($payment_methods['WebATM'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_webatm; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[ATM]" value="atm"<?php if (isset($payment_methods['ATM'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_atm; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[BARCODE]" value="barcode"<?php if (isset($payment_methods['BARCODE'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_barcode; ?>
                            </label>
                            <br />

                            <input type="checkbox" name="<?php echo $name_prefix; ?>_payment_methods[CVS]" value="cvs"<?php if (isset($payment_methods['CVS'])) { echo ' checked="checked"'; }    ?> />
                            <label class="control-label" for="input-<?php echo $id_prefix; ?>-payment-methods">
                                &nbsp;<?php echo $text_cvs; ?>
                            </label>
                            <br />
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-create-status">
                            <?php echo $entry_create_status; ?>
                        </label>
                        <div class="col-sm-8">
                            <select name="<?php echo $name_prefix; ?>_create_status" id="input-<?php echo $id_prefix; ?>-create-status" class="form-control">
                                <?php foreach ($order_statuses as $temp_status) { ?>
                                    <option value="<?php echo $temp_status['order_status_id']; ?>"<?php if ($temp_status['order_status_id'] == $create_status) { echo ' selected="selected"'; } ?>>
                                        <?php echo $temp_status['name']; ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-success-status">
                            <?php echo $entry_success_status; ?>
                        </label>
                        <div class="col-sm-8">
                            <select name="<?php echo $name_prefix; ?>_success_status" id="input-<?php echo $id_prefix; ?>-success-status" class="form-control">
                                
                                <?php foreach ($order_statuses as $temp_status) { ?>
                                    <option value="<?php echo $temp_status['order_status_id']; ?>"<?php if ($temp_status['order_status_id'] == $success_status) { echo ' selected="selected"'; } ?>>
                                        <?php echo $temp_status['name']; ?>
                                    </option>
                                <?php } ?>

                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-<?php echo $id_prefix; ?>-failed-status">
                            <?php echo $entry_failed_status; ?>
                        </label>
                        <div class="col-sm-8">
                            <select name="<?php echo $name_prefix; ?>_failed_status" id="input-<?php echo $id_prefix; ?>-failed-status" class="form-control">
                                <?php foreach ($order_statuses as $temp_status) { ?>
                                    <option value="<?php echo $temp_status['order_status_id']; ?>"<?php if ($temp_status['order_status_id'] == $failed_status) { echo ' selected="selected"'; } ?>>
                                        <?php echo $temp_status['name']; ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-geo-zone">
                            <?php echo $entry_geo_zone; ?>
                        </label>
                        <div class="col-sm-8">
                          <select name="<?php echo $name_prefix; ?>_geo_zone_id" id="input-<?php echo $id_prefix; ?>-geo-zone" class="form-control">
                            <option value="0"><?php echo $text_all_zones; ?></option>
                            <?php foreach ($geo_zones as $temp_zone) { ?>
                                <option value="<?php echo $temp_zone['geo_zone_id']; ?>"<?php if ($temp_zone['geo_zone_id'] == $geo_zone_id) { echo ' selected="selected"'; } ?>>
                                    <?php echo $temp_zone['name']; ?>
                                </option>
                            <?php } ?>
                          </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="input-<?php echo $id_prefix; ?>-sort-order">
                            <?php echo $entry_sort_order; ?>
                        </label>
                        <div class="col-sm-8">
                            <input type="text" name="<?php echo $name_prefix; ?>_sort_order" value="<?php echo $sort_order; ?>" placeholder="<?php echo $entry_sort_order; ?>" id="input-<?php echo $id_prefix; ?>-sort-order" class="form-control" />
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<?php echo $footer; ?>