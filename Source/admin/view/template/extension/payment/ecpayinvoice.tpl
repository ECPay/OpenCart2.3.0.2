<?php echo $header; ?>
<?php echo $column_left; ?>
<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <div class="pull-right">
        <button type="submit" form="form-popular" data-toggle="tooltip" title="<?php echo $button_save; ?>" class="btn btn-primary"><i class="fa fa-save"></i></button>
        <a href="<?php echo $cancel; ?>" data-toggle="tooltip" title="<?php echo $button_cancel; ?>" class="btn btn-default"><i class="fa fa-reply"></i></a></div>
      <h1><?php echo $heading_title; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
      </ul>
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
	<div class="panel panel-default">
      <div class="panel-heading">
        <h3 class="panel-title"><i class="fa fa-pencil"></i> <?php echo $text_edit; ?></h3>
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
              <label class="col-sm-2 control-label"for="input-<?php echo $id_prefix; ?>-mid">
                  <span data-toggle="tooltip" title="Merchant ID">
                      <?php echo $entry_mid; ?>
                  </span>
              </label>
              <div class="col-sm-8">
                  <input type="text" name="<?php echo $name_prefix; ?>_mid" value="<?php echo $mid; ?>" placeholder="Merchant ID" id="input-<?php echo $id_prefix; ?>-mid" class="form-control" />
              </div>
              <div class="text-danger"><?php echo $mid_error; ?></div>
          </div>

          <div class="form-group required">
              <label class="col-sm-2 control-label"for="input-<?php echo $id_prefix; ?>-hashkey">
                  <span data-toggle="tooltip" title="Merchant ID">
                      <?php echo $entry_hashkey; ?>
                  </span>
              </label>
              <div class="col-sm-8">
                  <input type="text" name="<?php echo $name_prefix; ?>_hashkey" value="<?php echo $hashkey; ?>" placeholder="Hash Key" id="input-<?php echo $id_prefix; ?>-hashkey" class="form-control" />
              </div>
              <div class="text-danger"><?php echo $hashkey_error; ?></div>
          </div>

          <div class="form-group required">
              <label class="col-sm-2 control-label"for="input-<?php echo $id_prefix; ?>-hashiv">
                  <span data-toggle="tooltip" title="Merchant ID">
                      <?php echo $entry_hashiv; ?>
                  </span>
              </label>
              <div class="col-sm-8">
                  <input type="text" name="<?php echo $name_prefix; ?>_hashiv" value="<?php echo $hashiv; ?>" placeholder="Hash IV" id="input-<?php echo $id_prefix; ?>-hashiv" class="form-control" />
              </div>
              <div class="text-danger"><?php echo $hashiv_error; ?></div>
          </div>

          <div class="form-group required">
              <label class="col-sm-2 control-label"for="input-<?php echo $id_prefix; ?>-url">
                  <span data-toggle="tooltip" title="Merchant ID">
                      <?php echo $entry_url; ?>
                  </span>
              </label>
              <div class="col-sm-8">
                  <input type="text" name="<?php echo $name_prefix; ?>_url" value="<?php echo $url; ?>" placeholder="URL" id="input-<?php echo $id_prefix; ?>-url" class="form-control" />
              </div>
              <div class="text-danger"><?php echo $url_error; ?></div>
          </div>

		      <div class="form-group">
            <label class="col-sm-2 control-label" for="input-ecpayinvoice-autoissue"><?php echo $entry_autoissue; ?></label>
            <div class="col-sm-10">
              <select name="<?php echo $name_prefix; ?>_autoissue" id="input-<?php echo $id_prefix; ?>-autoissue" class="form-control">
              <?php foreach ($module_autoissues as $temp_autoissue) { ?>
      					<?php if ($temp_autoissue['value'] == $autoissue) { ?>
      						<option value="<?php echo $temp_autoissue['value']; ?>" selected="selected"><?php echo $temp_autoissue['text']; ?></option>
      					<?php } else { ?>
      						<option value="<?php echo $temp_autoissue['value']; ?>"><?php echo $temp_autoissue['text']; ?></option>
      					<?php } ?>
      				<?php } ?>
      			  </select>
            </div>
          </div>
		    </form>
      </div>
    </div>
  </div>
</div>
<?php echo $footer; ?>