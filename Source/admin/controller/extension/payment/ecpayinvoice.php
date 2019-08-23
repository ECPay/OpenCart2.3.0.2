<?php
class ControllerExtensionPaymentECPayInvoice extends Controller 
{
	private $error = array();
	private $module_name = 'ecpayinvoice';
	private $module_code = '';
	private $lang_prefix = '';
	private $setting_prefix = '';
	private $name_prefix = '';
	private $id_prefix = '';
	private $module_path = '';
	private $extension_route = 'extension/extension';
	private $url_secure = true;
	private $validate_fields = array(
		'mid',
		'hashkey',
		'hashiv',
		'url'
	);

	// Constructor
	public function __construct($registry) {
		parent::__construct($registry);

		// Set the variables
		$this->module_code = '' . $this->module_name;
		$this->lang_prefix = $this->module_name .'_';
		$this->setting_prefix = '' . $this->module_name . '_';
		$this->name_prefix = '' . $this->module_name;
		$this->id_prefix = 'payment-' . $this->module_name;
		$this->module_path = 'extension/payment/' . $this->module_name;
	}

	public function index() 
	{
		// Load the translation file
		$this->load->language($this->module_path);

		// Set the title
		$heading_title = $this->language->get('heading_title');
		$this->document->setTitle($heading_title);

		// Load the Setting
        	$this->load->model('setting/setting');

		// Token
		$token = $this->session->data['token'];
		
		// Process the saving setting
		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			
			// Save the setting
			$this->model_setting_setting->editSetting(
			    $this->module_code,
               		    $this->request->post
			);

			// Define the success message
			$this->session->data['success'] = $this->language->get($this->lang_prefix . 'text_success');

			// Back to the payment list
			$redirect_url = $this->url->link(
				$this->extension_route,
				'token=' . $token . '&type=payment',
				$this->url_secure
			);

			$this->response->redirect($redirect_url);
		}
		
		// Get the translations
		$data['heading_title'] = $heading_title;

		$data['button_save'] = $this->language->get('button_save');
		$data['button_cancel'] = $this->language->get('button_cancel');

		// Get ECPay translations
	        $translation_names = array(
	            'text_edit',
	            'text_enabled',
	            'text_disabled',
	            'text_autoissue',
	            
	            'entry_status',
	            'entry_mid',
	            'entry_hashkey',
	            'entry_hashiv',
	            'entry_autoissue',
	            'entry_url',
	        );
	        foreach ($translation_names as $name) {
	            $data[$name] = $this->language->get($this->lang_prefix . $name);
	        }
	        unset($translation_names);

	        // Get the errors
	        if (isset($this->error['error_warning'])) {
	            $data['error_warning'] = $this->error['error_warning'];
	        } else {
	            $data['error_warning'] = '';
	        }

		// Get ECPay errors
	        foreach ($this->validate_fields as $name) {
	            $error_name = $name . '_error';
	            if(isset($this->error[$name])) {
	                $data[$error_name] = $this->error[$name];
	            } else {
	                $data[$error_name] = '';
	            }
	            unset($field_name, $error_name);
	        }
	        unset($error_fields);

	        // Set the breadcrumbs
		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
	            'text' => $this->language->get('text_home'),
	            'href' => $this->url->link('common/dashboard', 'token=' . $token, $this->url_secure)
	        );
	        $data['breadcrumbs'][] = array(
	            'text' => $this->language->get($this->lang_prefix . 'text_extension'),
	            'href' => $this->url->link(
	                $this->extension_route,
	                'token=' . $token . '&type=payment',
	                $this->url_secure
	            )
	        );
	        $data['breadcrumbs'][] = array(
	            'text' => $this->language->get('heading_title'),
	            'href' => $this->url->link(
	                'extension/payment/' . $this->module_name,
	                'token=' . $token,
	                $this->url_secure
	            )
	        );

	        // Set the form action
	        $data['action'] = $this->url->link(
	            $this->module_path,
	            'token=' . $token,
	            $this->url_secure
	        );
	        
	        // Set the cancel button
	        $data['cancel'] = $this->url->link(
	            $this->extension_route,
	            'token=' . $token,
	            $this->url_secure
	        );

	       // Get ECPay options
	        $options = array(
	            'status',
	            'mid',
	            'hashkey',
	            'hashiv',
	            'autoissue',
	            'url'
	        );
	        foreach ($options as $name) {
	            $option_name = $this->setting_prefix . $name;
	            if (isset($this->request->post[$option_name])) {
	                $data[$name] = $this->request->post[$option_name];
	            } else {
	                $data[$name] = $this->config->get($option_name);
	            }
	            unset($option_name);
	        }
	        unset($options);

	        // Default value
	        $default_values = array(
	            'mid' => '2000132',
	            'hashkey' => 'ejCk326UnaZWKisg',
	            'hashiv' => 'q9jcZX8Ib9LM8wYk',
	            'url' => 'https://einvoice-stage.ecpay.com.tw/Invoice/Issue',
	            // 'create_status' => 1,
	            // 'success_status' => 15,
	        );
	        foreach ($default_values as $name => $value) {
	            if (is_null($data[$name])) {
	                $data[$name] = $value;
	            }
	        }

	        // Set module status
	        $data['module_statuses'] = array(
	            array(
	                'value' => '1',
	                'text' => $this->language->get($this->lang_prefix . 'text_enabled')
	            ),
	            array(
	                'value' => '0',
	                'text' => $this->language->get($this->lang_prefix . 'text_disabled')
	            )
	        );

	        // Set module autoissues
	        $data['module_autoissues'] = array(
	            array(
	                'value' => '1',
	                'text' => $this->language->get($this->lang_prefix . 'text_enabled')
	            ),
	            array(
	                'value' => '0',
	                'text' => $this->language->get($this->lang_prefix . 'text_disabled')
	            )
	        );

	         // View's setting
	        $data['header'] = $this->load->controller('common/header');
	        $data['column_left'] = $this->load->controller('common/column_left');
	        $data['footer'] = $this->load->controller('common/footer');

	        $data['name_prefix'] = $this->name_prefix;
	        $data['id_prefix'] = $this->id_prefix;

		$view_path = $this->module_path;
		$this->response->setOutput($this->load->view($view_path, $data));
	}
	
	protected function validate() {
		// Premission validate
		if (!$this->user->hasPermission('modify', $this->module_path)) {
		    $this->error['error_warning'] = $this->language->get($this->lang_prefix . 'error_permission');
		}

		// Required fields validate
		foreach ($this->validate_fields as $name) {
		    $field_name = $this->setting_prefix . $name;
		    if (empty($this->request->post[$field_name])) {
		        $this->error[$name] = $this->language->get($this->lang_prefix . 'error_' . $name);
		    }
		    unset($field_name);
		}

		return !$this->error; 
	}
	
	// 手動開立發票
	public function createInvoiceNo()
	{
		$this->load->language('sale/order');
		
		$json = array();

		if (!$this->user->hasPermission('modify', 'sale/order'))
		{
			$json['error'] = $this->language->get('error_permission');
		}
		elseif (isset($this->request->get['order_id']))
		{
			if (isset($this->request->get['order_id']))
			{
				$order_id = $this->request->get['order_id'];
			}
			else
			{
				$order_id = 0;
			}
			
			$this->load->model('sale/order');
			
			
			// 判斷是否啟動ECPAY電子發票開立
			$nInvoice_Status = $this->config->get($this->setting_prefix . 'status');

			if($nInvoice_Status == 1)
			{
				// 1.參數初始化
				define('WEB_MESSAGE_NEW_LINE',	'|');	// 前端頁面訊息顯示換行標示語法
				$sMsg				= '' ;
				$sMsg_P2			= '' ;		// 金額有差異提醒
				$bError 			= false ; 	// 判斷各參數是否有錯誤，沒有錯誤才可以開發票
				
				// 2.取出開立相關參數
				
				// *連線資訊
				$sEcpayInvoiceUrlIssue		= $this->config->get($this->setting_prefix . 'url');		// 一般開立網址
				$nEcpayInvoiceMid 		= $this->config->get($this->setting_prefix . 'mid') ;		// 廠商代號
				$sEcpayInvoiceHashKey 		= $this->config->get($this->setting_prefix . 'hashkey');	// 金鑰
				$sEcpayInvoiceHashIV 		= $this->config->get($this->setting_prefix . 'hashiv') ;	// 向量

				// *訂單資訊
				$aOrderInfoTmp 			= $this->model_sale_order->getOrder($order_id);			// 訂單資訊
				$aOrderProductTmp  		= $this->model_sale_order->getOrderProducts($order_id);		// 訂購商品
				$aOrderTotalTmp  		= $this->model_sale_order->getOrderTotals($order_id);		// 訂單金額
				
				// *統編與愛心碼資訊
				$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "invoice_info WHERE order_id = '" . (int)$order_id . "'" );
					
				// 3.判斷資料正確性
				if( $query->num_rows == 0 )
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . '開立發票資訊不存在。';
				}
				else
				{
					$aInvoiceInfo = $query->rows[0] ;
				}
				
				// *URL判斷是否有值
				if($sEcpayInvoiceUrlIssue == '')
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . '請填寫發票傳送網址。';
				}
				
				// *MID判斷是否有值
				if($nEcpayInvoiceMid == '')
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . '請填寫商店代號(Merchant ID)。';
				}
				
				// *HASHKEY判斷是否有值
				if($sEcpayInvoiceHashKey == '')
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . '請填寫金鑰(Hash Key)。';
				}
				
				// *HASHIV判斷是否有值
				if($sEcpayInvoiceHashIV == '')
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . '請填寫向量(Hash IV)。';
				}
				
				// 判斷是否開過發票
				if($aOrderInfoTmp['invoice_no'] != 0)
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . '已存在發票紀錄，請重新整理頁面。';
				}
	
				// 判斷商品是否存在
				if(count($aOrderProductTmp) < 0)
				{
					$bError = true ;
					$sMsg .= ( empty($sMsg) ? '' : WEB_MESSAGE_NEW_LINE ) . ' 該訂單編號不存在商品，不允許開立發票。';
				}
				else
				{
					// 判斷商品是否含小數點
					foreach( $aOrderProductTmp as $key => $value)
					{
						if ( !strstr($value['price'], '.00') )
						{
							$sMsg_P2 .= ( empty($sMsg_P2) ? '' : WEB_MESSAGE_NEW_LINE ) . '提醒：商品 ' . $value['name'] . ' 金額存在小數點，將以無條件進位開立發票。';
						}
					}
				}

				if(!$bError)
				{
					$sLove_Code 			= '' ;
					$nDonation			= '2' ;
					$nPrint				= '0' ;
					$sCustomerIdentifier		= '' ;
					
					if($aInvoiceInfo['invoice_type'] == 1)
					{
						$nDonation 		= '2' ;					// 不捐贈
						$nPrint			= '0' ;
						$sCustomerIdentifier	= '' ;
					}
					elseif($aInvoiceInfo['invoice_type'] == 2)
					{
						$nDonation 		= '2' ;					// 公司發票 不捐贈
						$nPrint			= '1' ;					// 公司發票 強制列印
						$sCustomerIdentifier	= $aInvoiceInfo['company_write'] ;	// 公司統一編號
					}
					elseif($aInvoiceInfo['invoice_type'] == 3)
					{
						$nDonation 		= '1' ;
						$nPrint			= '0' ;
						$sLove_Code 		= $aInvoiceInfo['love_code'] ;
						$sCustomerIdentifier	= '' ;
					}
					else
					{
						$nDonation 		= '2' ;
						$nPrint			= '0' ;
						$sLove_Code 		= '' ;
						$sCustomerIdentifier	= '' ;	
					}
					
					// 4.送出參數
					try
					{
						$sFile_Name =  dirname(dirname(dirname(dirname(dirname(__FILE__))))) . DIRECTORY_SEPARATOR.'catalog'.DIRECTORY_SEPARATOR.'model'.DIRECTORY_SEPARATOR.'extension'.DIRECTORY_SEPARATOR.'payment'.DIRECTORY_SEPARATOR.'Ecpay_Invoice.php' ;

						include_once($sFile_Name);

						$ecpay_invoice = new EcpayInvoice ;
						
						// A.寫入基本介接參數
						$ecpay_invoice->Invoice_Method 			= 'INVOICE' ;
						$ecpay_invoice->Invoice_Url 			= $sEcpayInvoiceUrlIssue ;
						$ecpay_invoice->MerchantID 			= $nEcpayInvoiceMid ;
						$ecpay_invoice->HashKey 			= $sEcpayInvoiceHashKey ;
						$ecpay_invoice->HashIV 				= $sEcpayInvoiceHashIV ;
						
						// B.送出開立發票參數
						$aItems	= array();
						
						// *算出商品各別金額
						$nSub_Total_Real = 0 ;	// 實際無條進位小計
						
						foreach( $aOrderProductTmp as $key => $value)
						{
							$nQuantity 	= ceil($value['quantity']) ;
							$nPrice		= ceil($value['price']) ;
							$nTotal		= $nQuantity * $nPrice	 ; 				// 各商品小計

							$nSub_Total_Real = $nSub_Total_Real + $nTotal ;				// 計算發票總金額
							
						 	$sProduct_Name 	= $value['name'] ;
						 	$sProduct_Note 	= $value['model'] . '-' . $value['product_id'] ;

						 	mb_internal_encoding('UTF-8');
						 	$nString_Limit 	= 10 ;
						 	$nSource_Length = mb_strlen($sProduct_Note);
						 	
						 	if ( $nString_Limit < $nSource_Length )
					                {
					                        $nString_Limit = $nString_Limit - 3;

					                        if ( $nString_Limit > 0 )
					                        {
					                                $sProduct_Note = mb_substr($sProduct_Note, 0, $nString_Limit) . '...';
					                        }
					                }
						 	
							array_push($ecpay_invoice->Send['Items'], array('ItemName' => $sProduct_Name, 'ItemCount' => $nQuantity, 'ItemWord' => '批', 'ItemPrice' => $nPrice, 'ItemTaxType' => 1, 'ItemAmount' => $nTotal, 'ItemRemark' => $sProduct_Note )) ;
						}
						
						// *找出sub-total
						$nSub_Total = 0 ;
						foreach( $aOrderTotalTmp as $key2 => $value2)
						{
							if($value2['title'] == 'Sub-Total')
							{
								$nSub_Total = (int)$value2['value'];
								break;
							}	
						}
						
						// 無條件位後加總有差異
						if($nSub_Total != $nSub_Total_Real )
						{
							$sMsg_P2 .= ( empty($sMsg_P2) ? '' : WEB_MESSAGE_NEW_LINE ) . '綠界科技電子發票開立，實際金額 $' . $nSub_Total . '， 無條件進位後 $' . $nSub_Total_Real;
						}
						
						$RelateNumber	= $order_id ;
						// $RelateNumber = 'ECPAY'. date('YmdHis') . rand(1000000000,2147483647) ; // 產生測試用自訂訂單編號
						
						
						$ecpay_invoice->Send['RelateNumber'] 			= $RelateNumber ;
						$ecpay_invoice->Send['CustomerID'] 			= '' ;
						$ecpay_invoice->Send['CustomerIdentifier'] 		= $sCustomerIdentifier ;
						$ecpay_invoice->Send['CustomerName'] 			= $aOrderInfoTmp['firstname'] ;
						$ecpay_invoice->Send['CustomerAddr'] 			= $aOrderInfoTmp['payment_country'] . $aOrderInfoTmp['payment_postcode'] . $aOrderInfoTmp['payment_city'] . $aOrderInfoTmp['payment_address_1'] . $aOrderInfoTmp['payment_address_2'];
						$ecpay_invoice->Send['CustomerPhone'] 			= $aOrderInfoTmp['telephone'] ;
						$ecpay_invoice->Send['CustomerEmail'] 			= $aOrderInfoTmp['email'] ;
						$ecpay_invoice->Send['ClearanceMark'] 			= '' ;
						$ecpay_invoice->Send['Print'] 				= $nPrint ;
						$ecpay_invoice->Send['Donation'] 			= $nDonation ;
						$ecpay_invoice->Send['LoveCode'] 			= $sLove_Code ;
						$ecpay_invoice->Send['CarruerType'] 			= '' ;
						$ecpay_invoice->Send['CarruerNum'] 			= '' ;
						$ecpay_invoice->Send['TaxType'] 			= 1 ;
						$ecpay_invoice->Send['SalesAmount'] 			= $nSub_Total_Real ;	
						$ecpay_invoice->Send['InvType'] 			= '07' ;
						$ecpay_invoice->Send['vat'] 				= '' ;
						$ecpay_invoice->Send['InvoiceRemark'] 			= 'OC2_ECPayInvoice_2.0.190801' ;
						
						// C.送出與返回
						$aReturn_Info = $ecpay_invoice->Check_Out();
									
		
					}catch (Exception $e)
					{
						// 例外錯誤處理。
						$sMsg = $e->getMessage();
					}
					
					// 5.有錯誤訊息或回傳狀態RtnCode不等於1 則不寫入DB
					if( $sMsg != '' || !isset($aReturn_Info['RtnCode']) || $aReturn_Info['RtnCode'] != 1 )
					{
						$sMsg .= '綠界科技電子發票手動開立訊息' ;
						$sMsg .= (isset($aReturn_Info)) ? print_r($aReturn_Info, true) : '' ; 
						
						$json['error'] 		= $sMsg;
						$json['invoice_no'] 	= '';
						
						// A.寫入LOG
						$this->db->query("INSERT INTO " . DB_PREFIX . "order_history SET order_id = '" . (int)$order_id . "', order_status_id = '" . (int)$aOrderInfoTmp['order_status_id'] . "', notify = '0', comment = '" . $this->db->escape($sMsg) . "', date_added = NOW()");
	
					}
					else
					{
						// 無條件進位 金額有差異，寫入LOG提醒管理員
						if( $sMsg_P2 != '' )
						{
							$this->db->query("INSERT INTO " . DB_PREFIX . "order_history SET order_id = '" . (int)$order_id . "', order_status_id = '" . (int)$aOrderInfoTmp['order_status_id'] . "', notify = '0', comment = '" . $this->db->escape($sMsg_P2) . "', date_added = NOW()");
						} 
						
						// A.更新發票號碼欄位
						$invoice_no 		= $aReturn_Info['InvoiceNumber'] ;
						$json['invoice_no'] 	= $invoice_no;
						
						// B.整理發票號碼並寫入DB
						$sInvoice_No_Pre 	= substr($invoice_no ,0 ,2 ) ;
						$sInvoice_No 		= substr($invoice_no ,2) ; 
						
						// C.回傳資訊轉陣列提供history資料寫入
						$sReturn_Info		= '綠界科技電子發票手動開立訊息' ;
						$sReturn_Info		.= print_r($aReturn_Info, true);
						
						//$sInvoice_No_Pre = 'TEST' ;
						//$sInvoice_No	= 0 ;
						
						$this->db->query("UPDATE `" . DB_PREFIX . "order` SET invoice_no = '" . $sInvoice_No . "', invoice_prefix = '" . $this->db->escape($sInvoice_No_Pre) . "' WHERE order_id = '" . (int)$order_id . "'");
						$this->db->query("INSERT INTO " . DB_PREFIX . "order_history SET order_id = '" . (int)$order_id . "', order_status_id = '" . (int)$aOrderInfoTmp['order_status_id'] . "', notify = '0', comment = '" . $this->db->escape($sReturn_Info) . "', date_added = NOW()");
					}
				}
				else
				{
					$json['error'] 	= $sMsg;	
				}	
			}
			else
			{
				
				$invoice_no = $this->model_sale_order->createInvoiceNo($order_id);
				
				if($invoice_no)
				{
					$json['invoice_no'] = $invoice_no;
				}
				else
				{
					$json['error'] = $this->language->get('error_action');
				}
			}

		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
		//echo json_encode($json);


		// exit;
	}
	
	public function install() 
	{
		$this->db->query("
			CREATE TABLE IF NOT EXISTS `" . DB_PREFIX . "invoice_info` (
			  `order_id` INT(11) NOT NULL,
			  `love_code` VARCHAR(50) NOT NULL,
			  `company_write` VARCHAR(10) NOT NULL,
			  `invoice_type` TINYINT(2) NOT NULL,
			  `createdate` INT(10)  NOT NULL
			) DEFAULT COLLATE=utf8_general_ci;");
			
		// 異動電子發票欄位型態
		$this->db->query(" ALTER TABLE `" . DB_PREFIX . "order` CHANGE `invoice_no` `invoice_no` VARCHAR(10) NOT NULL DEFAULT '0'; ");	
		$sFieldName = 'code';
		$sFieldValue = 'payment_' . $this->module_name;
		$query = $this->db->query("SHOW COLUMNS FROM " . DB_PREFIX . "setting LIKE 'code'");
		if ( $query->num_rows == 0 )
		{
			$sFieldName = 'group';
		} 
	}
}