import React from 'react'; 
import '../stylesheets/MenuItem.css';

type MenuItemState = {
}

type MenuItemProps = {
    name: string,
    image: string,
    status: string,
    quantity: number,
    updateQuantity(name: string, modify: number): void,
}

class MenuItem extends React.Component<MenuItemProps,MenuItemState>{
    
    render() {
        return(
            <div className="MenuItem">
                <div className="MenuLeft">
                    <img src={this.props.image} alt="Italian Trulli" style={{objectFit:"cover", height:"100%", width:"20vw",borderTopLeftRadius:"5px", borderBottomLeftRadius:"5px"}}/>
                        <h2 style={{marginLeft:"10px", fontSize:"4vw"}}>
                            {this.props.name} 
                        </h2>
                        <h2 style={{marginLeft:"10px", fontSize:"4vw", fontWeight:100}}>
                        - {this.props.status}
                        </h2>
                    </div>
                <div className="MenuRight">
                    <button className="increment" onClick={() => this.props.updateQuantity(this.props.name,-1)}>
                        -
                    </button>
                    <h2 style={{fontSize:"4vw"}}>
                        {this.props.quantity}
                    </h2>
                    <button className="increment" onClick={() => this.props.updateQuantity(this.props.name,1)}>
                        +
                    </button>
                </div>
            </div>
        )
    }
}

export default MenuItem;
