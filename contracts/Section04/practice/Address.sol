// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

/** 
 * @title Address Typeを学ぼう
 */
contract Address {


    /// @dev msg.senderはクエリ/トランザクション元アカウントアドレスが入っているグローバル変数
    address public fromAddr;

    constructor() {
        fromAddr = msg.sender;
    }

    /// @dev アカウントアドレス(EOA)の所有ETHを取得
    function getBalance() public view returns (uint256) {
        uint256 balance = fromAddr.balance;
        return balance;
    }
    /// @dev コントラクトのバイトコードを取得
    function getByteCode() public view returns(bytes memory) {
        return address(this).code;
    }
    /// @dev コントラクトのバイトコードハッシュを取得
    function getByteCodeHash() public view returns(bytes32) {
        return address(this).codehash;
    }
    function getByteCodeHash2() public view returns(bytes32) {
        return keccak256(address(this).code);
    }
    /** 
     * @dev ETH送金 transfer/send/callの違い
     * transfer:宛先がコントラクトのアドレスである場合、
     * そのコード (Receive Ether Functionまたは Fallback Functionが存在すれば実行される
     * この実行がガス欠になったり、何らかの形で失敗した場合、
     * Ether転送は元に戻り、現在のコントラクトは例外を発生させて停止する
     *
     * send:transferの低レベルファンクション。実行に失敗した場合、現在のコントラクトは例外で停止しないが、sendはfalseを返す
     * 安全なEther転送を行うには、常にsendの戻り値を確認し、transferを使用するか、
     * より良い方法として受信者がお金を引き出すwithdrawパターンを使用する
     *
     * call:ABIに準拠しないコントラクトとのインタフェースや、エンコーディングをより直接的に制御するために用意されている。
     * これらはすべて1バイトのメモリパラメータを取り、成功条件（bool）と返されたデータ（バイトメモリ）を返す
     * (※1) ABI(アプリケーションバイナリインターフェース）は、ブロックチェーンの外からとコントラクト間の相互作用の両方において、
     *      Ethereum内のコントラクトと対話するための標準的な方法
     */    

    /// @dev 宛先アドレスにtransferでETHを移転(移転の場合send/callよりもtransferを使おう)
    function transfer(address payable to) public payable {
        to.transfer(msg.value);
    }

    /// @dev 宛先アドレスにsendでETHを移転
    function send(address payable to) public payable returns (bool) {
        bool result = to.send(msg.value);
        require(result, "Failed");
        return result;
    }


    /// @dev 宛先アドレスにcallでETHを移転
    function call(address payable to) public payable returns (bool, bytes memory) {
        (bool result, bytes memory data) = to.call{value: msg.value}("");
        require(result, "Failed");
        return (result, data);
    }

}
