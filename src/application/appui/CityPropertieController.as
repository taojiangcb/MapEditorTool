package application.appui
{
	import com.frameWork.uiControls.UIMoudleManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	
	import spark.components.Alert;
	
	import application.AppReg;
	import application.ApplicationMediator;
	import application.db.CityNodeVO;
	import application.mapEditor.comps.MapCityNodeComp;
	import application.mapEditor.ui.MapEditorPanelConstroller;
	import application.utils.appData;
	import application.utils.appDataProxy;
	import application.utils.roadDataProxy;
	
	import gframeWork.uiController.MainUIControllerBase;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class CityPropertieController extends MainUIControllerBase
	{
		public var roadEditor:RoadEditor;
		public function CityPropertieController() 	{
			super();
			autoClose = false;
		}
		
		protected override function uiCreateComplete(event:FlexEvent):void {
			super.uiCreateComplete(event);
			ui.btnUpdateCityNode.addEventListener(MouseEvent.CLICK,updateCityNodeInfo,false,0,true);
			ui.freeCheck.addEventListener(Event.CHANGE,freeChangelHandler,false,0,true);
			ui.roadCheck.addEventListener(Event.CHANGE,roadCheckHandler,false,0,true);
			ui.btnAddRoad.addEventListener(MouseEvent.CLICK,addRoadHandler,false,0,true);
			ui.delCity.addEventListener(MouseEvent.CLICK,delCityHandler,false,0,true);
			ui.flagCheck.addEventListener(MouseEvent.CLICK,flagCheckHandler,false,0,true);
			ui.reversalCheck.addEventListener(MouseEvent.CLICK,reversalChangeHandler,false,0,true);
			ui.offsetX.addEventListener(Event.CHANGE,offsetXChangeHandler,false,0,true);
			commitData();
			roadEditor = new RoadEditor(mapEditor);
		}
		
		public function setChrooseCity(cityComp:MapCityNodeComp):void {
			if(roadEditor)	roadEditor.setCurCity(cityComp);
		}
		
		public function commitData():void {
			if(chrooseCityComp && ui.initialized) {
				ui.enabled = true;
				ui.txtName.text = chrooseCityComp.cityName;
				ui.txtCityTempId.text = chrooseCityComp.templateId.toString();
				ui.freeCheck.selected = chrooseCityComp.freeVisible;
				ui.roadCheck.selected = chrooseCityComp.roadVisible;
				ui.flagCheck.selected = chrooseCityComp.flagVisible;
				ui.reversalCheck.selected = chrooseCityComp.reversal;
				ui.offsetX.value = chrooseCityComp.offsetX;
			} else {
				ui.enabled = false;
			}
		}
		
		private function offsetXChangeHandler(event:Event):void {
			chrooseCityComp.offsetX = ui.offsetX.value;
		}
		
		private function roadCheckHandler(event:Event):void {
			chrooseCityComp.roadVisible = ui.roadCheck.selected;
			Facade.getInstance().sendNotification(ApplicationMediator.DRAW_ROAD);
		}
		
		private function reversalChangeHandler(event:MouseEvent):void {
			chrooseCityComp.reversal = ui.reversalCheck.selected;
		}
		
		/**
		 * 当前城市添加一条道路 
		 * @param event
		 * 
		 */		
		private function addRoadHandler(event:MouseEvent):void {
			roadEditor.addRoad();
		}
		
		private function updateCityNodeInfo(event:MouseEvent):void {
			var cityName:String = ui.txtName.text;
			var cityTemplateId:Number = Number(ui.txtCityTempId.text);
			
			var existMapNodeInfo:CityNodeVO = appDataProxy.getCityNodeInfoByTemplateId(cityTemplateId);
			if(existMapNodeInfo && existMapNodeInfo != chrooseCityComp.cityNodeInfo) {
				Alert.show("此城市id已经被其他城市占用了，请换一个id");
			} else {
				
				//更新相关的路径和节点
				roadDataProxy.updateCityId(chrooseCityComp.templateId,cityTemplateId)
				
				chrooseCityComp.cityName = ui.txtName.text;
				chrooseCityComp.templateId = cityTemplateId;
				
				Facade.getInstance().sendNotification(ApplicationMediator.DRAW_ROAD);
			}
		}
		
		/**
		 * 预览城市点火状态 
		 * @param event
		 */		
		private function freeChangelHandler(event:Event):void {
			if(chrooseCityComp) {
				chrooseCityComp.freeVisible = !chrooseCityComp.freeVisible; 
			}
		}
		
		/**
		 * 预览旗子显示的位置 
		 * @param event
		 * 
		 */		
		private function flagCheckHandler(event:Event):void {
			if(chrooseCityComp) {
				chrooseCityComp.flagVisible = !chrooseCityComp.flagVisible; 
			}
		}
		
		private function delCityHandler(event:MouseEvent):void {
			Alert.show("你确定要删除当前选定的城市吗？将会删除一切关联的道路数据!","删除城驰",Alert.YES|Alert.NO,null,onCloseHandler);
		}
		
		/**
		 * 确定删除城市 
		 * @param event
		 */	
		private function onCloseHandler(event:CloseEvent):void {
			if(event.detail == Alert.YES) {
				mapEditor.delCityComp(mapEditor.getChrroseCity().cityNodeInfo.templateId);
			}
		}
		
		public override function dispose():void {
			super.dispose();
			if(ui) {
				ui.btnAddRoad.removeEventListener(MouseEvent.CLICK,addRoadHandler);
			}
		}
	
		public function get ui():CityPropertiePanel {
			return mGUI as CityPropertiePanel;
		}
		
		/**
		 * 地图编辑 
		 * @return 
		 */		
		private function get mapEditor():MapEditorPanelConstroller {
			return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller
		}
		
		/**
		 * 当前选中的城市节点 
		 * @return 
		 */		
		public function get chrooseCityComp():MapCityNodeComp {
			return mapEditor.getChrroseCity();
		}
	}
}

import com.frameWork.uiControls.UIMoudleManager;
import flash.events.MouseEvent;
import mx.events.CloseEvent;
import spark.components.Alert;
import application.AppReg;
import application.appui.CityPropertieController;
import application.appui.CityPropertiePanel;
import application.appui.itemRenderer.RoadEditItemRenderer;
import application.db.CityNodeVO;
import application.mapEditor.comps.MapCityNodeComp;
import application.mapEditor.ui.MapEditorPanelConstroller;
import application.utils.appDataProxy;
import application.utils.roadDataProxy;

import gframeWork.uiController.UserInterfaceManager;

/**
 * 道路编辑管理 
 * @author JiangTao
 */
class RoadEditor {
	
	private var mapEdit:MapEditorPanelConstroller;
	private var curCityComp:MapCityNodeComp;
	
	private var roadComps:Vector.<RoadEditItemRenderer>;
	
	public function RoadEditor(mapEditor:MapEditorPanelConstroller):void {
		mapEdit = mapEditor;
		roadComps = new Vector.<RoadEditItemRenderer>();
	}
	
	public function setCurCity(cityComp:MapCityNodeComp):void {
		if(cityComp == curCityComp) return;
		curCityComp = cityComp;	
		updateRoadList();
	}
	
	private function updateRoadList():void {
		clearRoad();
		initRoads();
	}
	
	/**
	 * 初始化当前城市的所有道路 
	 */	
	private function initRoads():void {
		if(curCityComp) {
			var toCityids:Array = curCityComp.cityNodeInfo.toCityIds;
			var i:int = toCityids.length;
			while(--i > -1) {
				var roadEditorItem:RoadEditItemRenderer = new RoadEditItemRenderer();
				roadEditorItem.setCityId(toCityids[i]);
				propertiesUI.roadListContent.addElement(roadEditorItem);
				roadComps.push(roadEditorItem);
			}
		}
	}
	
	public function clearRoad():void {
		var i:int = roadComps.length;
		var roadEdit:RoadEditItemRenderer;
		while(--i > -1) {
			roadEdit = roadComps[i];
			if(roadEdit.parent) {
				propertiesUI.roadListContent.removeElement(roadEdit);
				roadEdit.dispose();
			}
		}
		roadComps = new Vector.<RoadEditItemRenderer>();
	}
	
	/**
	 * 添加一条道路
	 */	
	public function addRoad():void {
		if(curCityComp) {
			var roadEditorItem:RoadEditItemRenderer = new RoadEditItemRenderer();
			propertiesUI.roadListContent.addElement(roadEditorItem);
			roadComps.push(roadEditorItem);
		}
	}
	
	/**
	 * 删除一条道路 
	 * @param roadComp
	 */	
	public function removeRoad(roadComp:RoadEditItemRenderer):void {
		var existIndex:int = roadComps.indexOf(roadComp);
		if(existIndex > -1) {
			var toCityId:Number = -1;
			
			//删除组件
			if(roadComp.parent) {
				toCityId = roadComp.getCityId();
				propertiesUI.roadListContent.removeElement(roadComp);
				roadComp.dispose();
			}
			
			if(toCityId > 0) {
				var curCityInfo:CityNodeVO = curCityComp.cityNodeInfo;
				var toCityInfo:CityNodeVO = appDataProxy.getCityNodeInfoByTemplateId(toCityId);
				var curCityId:Number = curCityInfo.templateId;
				
				//删除正向道路
				var index:int = curCityInfo.toCityIds.indexOf(toCityId);
				if(index > -1) {
					curCityInfo.toCityIds.splice(index,1);
				}
				
				//删除返向道路
				index = toCityInfo.toCityIds.indexOf(curCityId);
				if(index > -1) {
					toCityInfo.toCityIds.splice(index,1);
				}
				
				//删除当前的道路
				mapEditor.ui.roadSpace.delRoad(curCityId,toCityId);
			}
		}
	}
	
	private function get cityPropertie():CityPropertieController {
		return UserInterfaceManager.getUIByID(AppReg.CITY_EDIT_PROPERTIES) as CityPropertieController;
	}
	
	private function get propertiesUI():CityPropertiePanel {
		return cityPropertie.ui;
	}
	
	public function get mapEditor():MapEditorPanelConstroller {
		return UIMoudleManager.getUIMoudleByOpenId(AppReg.EDITOR_MAP_PANEL) as MapEditorPanelConstroller;
	}
}
