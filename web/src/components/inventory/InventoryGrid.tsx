import React, { useEffect, useMemo, useRef, useState } from 'react';
import { Inventory } from '../../typings';
import WeightBar from '../utils/WeightBar';
import InventorySlot from './InventorySlot';
import { getTotalWeight } from '../../helpers';
import { useAppSelector } from '../../store';
import { useIntersection } from '../../hooks/useIntersection';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faList, faBriefcase, faUserTie } from '@fortawesome/free-solid-svg-icons';

const PAGE_SIZE = 30;

const InventoryGrid: React.FC<{ inventory: Inventory }> = ({ inventory }) => {
  const weight = useMemo(
    () => (inventory.maxWeight !== undefined ? Math.floor(getTotalWeight(inventory.items) * 1000) / 1000 : 0),
    [inventory.maxWeight, inventory.items]
  );
  const [page, setPage] = useState(0);
  const containerRef = useRef(null);
  const { ref, entry } = useIntersection({ threshold: 0.5 });
  const isBusy = useAppSelector((state) => state.inventory.isBusy);

  useEffect(() => {
    if (entry && entry.isIntersecting) {
      setPage((prev) => ++prev);
    }
  }, [entry]);
  return (
    <>
      <div className={inventory.type === 'player' ? "inventory-grid-wrapper-user" : "inventory-grid-wrapper"} style={{ pointerEvents: isBusy ? 'none' : 'auto' }}>
        <div>
          <div className={inventory.type === 'player' ? "inventory-grid-header-wrapper-user" : "inventory-grid-header-wrapper"}>
          {inventory.type === 'player' &&                     
            <div className='LabelName'>
              <div className="iconWrapper2">
                <FontAwesomeIcon icon={faUserTie} />
              </div> 
              {inventory.label}
            </div>}
          <p className='LabelText'>
                {inventory.type === 'player' ? (
                    <div className="iconWrapper">
                      <FontAwesomeIcon icon={faBriefcase} />
                    </div>
                ) : (
                    <div className="iconWrapper">
                        <FontAwesomeIcon icon={faList} />
                    </div>
                )}
                {inventory.type === 'player' ? "Inventory" : inventory.label === undefined ? "Other" : inventory.label}
            </p>
            <div className={inventory.type === 'player' ? "WeightBarWrap" : "WeightBarWrap2"}>
            <WeightBar percent={inventory.maxWeight ? (weight / inventory.maxWeight) * 100 : 0} />
            </div>
            {inventory.maxWeight && (
              <p className='WeightText' style={{ marginRight: inventory.type === 'player' ? 15 : 0 }}>
                Weight: {weight / 1000}/{inventory.maxWeight / 1000}kg
              </p>
            )}
          </div>
        </div>
        <div className={inventory.type === 'player' ? "inventory-grid-container-user" : "inventory-grid-container"} ref={containerRef}>
          {inventory.type === 'player' ? (
            <>
              <div className='RegularSlots'>
                {inventory.items.slice(0, 30).map((item, index) => (
                  <InventorySlot
                    key={`${inventory.type}-${inventory.id}-${item.slot}`}
                    item={item}
                    ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                ))}
                {inventory.items.slice(44, 150).map((item, index) => (
                  <InventorySlot
                    key={`${inventory.type}-${inventory.id}-${item.slot}`}
                    item={item}
                    ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                    inventoryType={inventory.type}
                    inventoryGroups={inventory.groups}
                    inventoryId={inventory.id}
                  />
                ))}
              </div>
              <div className="ClothingSlots">
                <div className='Clothing1'>
                  {inventory.items.slice(30, 37).map((item, index) => (
                    <InventorySlot
                      key={`${inventory.type}-${inventory.id}-${item.slot}`}
                      item={item}
                      ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                      inventoryType={inventory.type}
                      inventoryGroups={inventory.groups}
                      inventoryId={inventory.id}
                    />
                  ))}
                </div>
                <img style={{ height: '41rem' }} src="nui://ox_inventory/web/images/char.png" alt="Character Image Missing (Read Docs)" />

                <div className='Clothing2'>
                  {inventory.items.slice(37, 44).map((item, index) => (
                    <InventorySlot
                      key={`${inventory.type}-${inventory.id}-${item.slot}`}
                      item={item}
                      ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                      inventoryType={inventory.type}
                      inventoryGroups={inventory.groups}
                      inventoryId={inventory.id}
                    />
                  ))}
                </div>

              </div>
            </>
          ) : (
            <>
              {inventory.items.slice(0, (page + 1) * PAGE_SIZE).map((item, index) => (
                <InventorySlot
                  key={`${inventory.type}-${inventory.id}-${item.slot}`}
                  item={item}
                  ref={index === (page + 1) * PAGE_SIZE - 1 ? ref : null}
                  inventoryType={inventory.type}
                  inventoryGroups={inventory.groups}
                  inventoryId={inventory.id}
                />
              ))}
            </>
          )}
        </div>
      </div>
    </>
  );
};

export default InventoryGrid;
