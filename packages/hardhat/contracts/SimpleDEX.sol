//https://sepolia.scrollscan.com/address/0xF187eA9199dC50B6604B46A54909B90D999Ef391
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


pragma solidity ^0.8.0;


contract SimpleDEX {
    address public owner;
    IERC20 public tokenA;
    IERC20 public tokenB;

    uint256 public reserveA;
    uint256 public reserveB;

    // Eventos
    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);
    event TokensSwapped(address indexed user, address indexed fromToken, address indexed toToken, uint256 amountIn, uint256 amountOut);
    event BalanceUpdated(address indexed token, uint256 newBalance);

    // acceso a solo el owner
    modifier onlyOwner() {
        require(msg.sender == owner, "SimpleDEX: Only owner can add liquidity");
        _;
    }

    constructor(address _tokenA, address _tokenB) {
        owner = msg.sender;
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    // Función para añadir liquidez (solo puede ser ejecutada por el owner)
    function addLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(amountA > 0 && amountB > 0, "SimpleDEX: Amounts must be greater than 0");

        // Transferir los tokens al contrato
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transferFrom(msg.sender, address(this), amountB);

        // Actualizar reservas
        reserveA += amountA;
        reserveB += amountB;

        // Emitir evento de adición de liquidez
        emit LiquidityAdded(msg.sender, amountA, amountB);
        emit BalanceUpdated(address(tokenA), reserveA);
        emit BalanceUpdated(address(tokenB), reserveB);
    }

    // Función para retirar liquidez
    function removeLiquidity(uint256 amountA, uint256 amountB) external onlyOwner {
        require(amountA <= reserveA && amountB <= reserveB, "SimpleDEX: Not enough liquidity");

        reserveA -= amountA;
        reserveB -= amountB;

        tokenA.transfer(msg.sender, amountA);
        tokenB.transfer(msg.sender, amountB);

        emit LiquidityRemoved(msg.sender, amountA, amountB);
        emit BalanceUpdated(address(tokenA), reserveA);
        emit BalanceUpdated(address(tokenB), reserveB);
    }

    // Función para intercambiar TokenA por TokenB
    function swapAforB(uint256 amountAIn) external {
        require(amountAIn > 0, "SimpleDEX: Invalid amount");

        uint256 _reserveA = tokenA.balanceOf(address(this));
        uint256 _reserveB = tokenB.balanceOf(address(this));

        // Cálculo de la cantidad de TokenB a recibir (dY) usando la fórmula del producto constante
        uint256 dY = _reserveB - ((_reserveA * _reserveB) / (_reserveA + amountAIn));
        uint256 amountBOut = _reserveB - dY;

        require(amountBOut > 0, "SimpleDEX: Insufficient liquidity");

        // Transferir TokenA al contrato
        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        // Transferir TokenB al usuario
        tokenB.transfer(msg.sender, amountBOut);

        // Actualizar las reservas después del swap
        reserveA += amountAIn;
        reserveB -= amountBOut;

        // Emitir evento de swap
        emit TokensSwapped(msg.sender, address(tokenA), address(tokenB), amountAIn, amountBOut);
        emit BalanceUpdated(address(tokenA), reserveA);
        emit BalanceUpdated(address(tokenB), reserveB);
    }

    // Función para intercambiar TokenB por TokenA
    function swapBforA(uint256 amountBIn) external {
        require(amountBIn > 0, "SimpleDEX: Invalid amount");

        uint256 _reserveA = tokenA.balanceOf(address(this));
        uint256 _reserveB = tokenB.balanceOf(address(this));

        // Cálculo de la cantidad de TokenA a recibir (dX) usando la fórmula del producto constante
        uint256 dX = _reserveA - ((_reserveA * _reserveB) / (_reserveB + amountBIn));
        uint256 amountAOut = _reserveA - dX;

        require(amountAOut > 0, "SimpleDEX: Insufficient liquidity");

        // Transferir TokenB al contrato
        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        // Transferir TokenA al usuario
        tokenA.transfer(msg.sender, amountAOut);

        // Actualizar las reservas después del swap
        reserveA -= amountAOut;
        reserveB += amountBIn;

        // Emitir evento de swap
        emit TokensSwapped(msg.sender, address(tokenB), address(tokenA), amountBIn, amountAOut);
        emit BalanceUpdated(address(tokenA), reserveA);
        emit BalanceUpdated(address(tokenB), reserveB);
    }

    // Función para obtener el precio de un token (por ejemplo, TokenA en términos de TokenB)
    function getPrice(address _token) external view returns (uint256) {
        uint256 _reserveA = tokenA.balanceOf(address(this));
        uint256 _reserveB = tokenB.balanceOf(address(this));

        require(_reserveA > 0 && _reserveB > 0, "SimpleDEX: Insufficient liquidity to calculate price");

        if (_token == address(tokenA)) {
            // Precio de TokenA en términos de TokenB, con 18 decimales de precisión
            return (_reserveB * 10**18) / _reserveA;
        } else if (_token == address(tokenB)) {
            // Precio de TokenB en términos de TokenA, con 18 decimales de precisión
            return (_reserveA * 10**18) / _reserveB;
        } else {
            revert("SimpleDEX: Invalid token");
        }
    }
}