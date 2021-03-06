<?php

use PHPUnit\Framework\TestCase;
use WEEEOpen\Tarallo\InvalidParameterException;
use WEEEOpen\Tarallo\ItemIncomplete;

class ItemIncompleteTest extends TestCase {
	/**
	 * @covers         \WEEEOpen\Tarallo\ItemIncomplete
	 */
	public function testItemValidCodeString() {
		$pc77 = new ItemIncomplete('PC-77');
		$this->assertEquals('PC-77', (string) $pc77);
		$this->assertEquals('PC-77', $pc77->getCode());
	}

	/**
	 * @covers         \WEEEOpen\Tarallo\ItemIncomplete
	 */
	public function testItemValidCodeInt() {
		$quarantadue = new ItemIncomplete(42);
		$this->assertEquals('42', (string) $quarantadue);
		$this->assertEquals(42, $quarantadue->getCode());
	}

	/**
	 * @covers         \WEEEOpen\Tarallo\ItemIncomplete
	 */
	public function testItemNullCode() {
		$this->expectException(InvalidParameterException::class);
		new ItemIncomplete(null);
	}

	/**
	 * @covers         \WEEEOpen\Tarallo\ItemIncomplete
	 */
	public function testItemEmptyCode() {
		$this->expectException(InvalidParameterException::class);
		new ItemIncomplete('');
	}

	/**
	 * @covers         \WEEEOpen\Tarallo\ItemIncomplete
	 */
	public function testItemArrayCode() {
		$this->expectException(InvalidParameterException::class);
		new ItemIncomplete(["cose" => "a caso"]);
	}

	/**
	 * @covers         \WEEEOpen\Tarallo\ItemIncomplete
	 */
	public function testJsonSerialize() {
		$i = new ItemIncomplete("TEST");
		$this->assertEquals('TEST', $i->jsonSerialize());
		$this->assertEquals('"TEST"', json_encode($i));
	}
}