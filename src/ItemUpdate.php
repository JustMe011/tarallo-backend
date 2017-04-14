<?php

namespace WEEEOpen\Tarallo;


class ItemUpdate extends Item implements \JsonSerializable {
	private $isDefault = false;
	private $parent = null;

	private $isDefaultChanged = false;
	private $defaultCodeChanged = false;
	private $parentChanged = false;
	private $featuresChanged = false;

	public function __construct($code) {
		parent::__construct($code, null);
	}

	public function setDefaultCode($code) {
		if($code === null) {
			$this->defaultCode = null;
		} else {
			$this->defaultCode = $this->sanitizeCode($code);
		}
		$this->defaultCodeChanged = true;
		return $this;
	}

	public function getDefaultCodeChanged() {
		return $this->defaultCodeChanged;
	}

	public function getIsDefaultChanged() {
		return $this->isDefaultChanged;
	}

	public function setIsDefault($is) {
		$this->isDefault = (bool) $is;
		$this->isDefaultChanged = true;
		return $this;
	}

	protected static function featureValueIsValid($value) {
		if(parent::featureValueIsValid($value)) {
			return true;
		} else if($value === null) {
			return true;
		} else {
			return false;
		}
	}

	public function addFeatureDefault($name, $value) {
		throw new \LogicException('Cannot add default features to ItemUpdate as they will be ignored');
	}

	public function getParent() {
		return $this->parent;
	}

	public function setParent($parent) {
		if($parent instanceof ItemIncomplete || $parent === null) {
			$this->parent = $parent;
		} else {
			throw new \InvalidArgumentException('Parent should be an instance of ItemIncomplete or null, ' . gettype($parent) . ' given');
		}
		$this->parentChanged = true;
		return $this;
	}

	public function getParentChanged() {
		return $this->parentChanged;
	}

	public function addFeature($name, $value) {
		$this->featuresChanged = true;
		return parent::addFeature($name, $value);
	}

	public function setFeaturesChanged() {
		$this->featuresChanged = true;
	}
}